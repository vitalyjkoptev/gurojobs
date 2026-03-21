<?php

namespace App\Services;

use App\Models\GuroNotification;
use App\Models\Job;
use App\Models\JobApplication;
use App\Models\User;
use App\Services\Telegram\TelegramService;
use Illuminate\Support\Facades\Log;

class NotificationService
{
    /**
     * Планы с Telegram-уведомлениями о новых кандидатах.
     */
    protected const TELEGRAM_PLANS = ['vip'];

    /**
     * Уведомить рекрутера о новом отклике на его вакансию.
     *
     * Flow:
     * 1. Кандидат откликнулся на вакансию
     * 2. Находим владельца вакансии (рекрутер)
     * 3. Создаём in-app уведомление
     * 4. Если рекрутер на Business/Enterprise плане + подключил Telegram → шлём в Telegram
     */
    public static function notifyNewApplication(JobApplication $application): void
    {
        try {
            $job = $application->job()->with('company.owner')->first();
            if (!$job || !$job->company || !$job->company->owner) {
                return;
            }

            $employer = $job->company->owner;
            $candidate = User::find($application->candidate_id);
            if (!$candidate) return;

            $candidateName = $candidate->name ?? 'Unknown';
            $jobTitle = $job->title ?? 'Job';

            // 1. In-app уведомление (всегда)
            GuroNotification::create([
                'user_id' => $employer->id,
                'type' => 'new_application',
                'title' => "New candidate for \"{$jobTitle}\"",
                'body' => "{$candidateName} applied for your job \"{$jobTitle}\"",
                'data' => [
                    'job_id' => $job->id,
                    'job_title' => $jobTitle,
                    'application_id' => $application->id,
                    'candidate_id' => $candidate->id,
                    'candidate_name' => $candidateName,
                ],
                'channel' => 'in-app',
                'created_at' => now(),
            ]);

            // 2. Telegram уведомление (только для Business/Enterprise + привязан Telegram)
            $plan = $employer->currentPlan();
            $hasTelegram = !empty($employer->telegram_id);

            if (in_array($plan, self::TELEGRAM_PLANS) && $hasTelegram) {
                self::sendTelegramNotification($employer, $job, $candidate, $application);
            }

        } catch (\Exception $e) {
            Log::error("NotificationService::notifyNewApplication error: {$e->getMessage()}");
        }
    }

    /**
     * Отправить Telegram-уведомление рекрутеру.
     */
    protected static function sendTelegramNotification(
        User $employer,
        Job $job,
        User $candidate,
        JobApplication $application
    ): void {
        try {
            $telegram = new TelegramService();

            $candidateName = $candidate->name ?? 'Candidate';
            $jobTitle = $job->title ?? 'Job';
            $jobUrl = config('app.url') . '/jobs/' . ($job->slug ?? $job->id);
            $resumeUrl = $application->resume_path
                ? config('app.url') . '/storage/' . $application->resume_path
                : null;

            // Собираем профиль кандидата
            $profile = $candidate->candidateProfile;
            $location = $profile->location ?? '';
            $experience = $profile->desired_position ?? '';

            $text = "🆕 <b>New candidate!</b>\n\n";
            $text .= "👤 <b>{$candidateName}</b>\n";
            if ($location) $text .= "📍 {$location}\n";
            if ($experience) $text .= "💼 {$experience}\n";
            $text .= "\n";
            $text .= "📋 Applied for: <b>{$jobTitle}</b>\n";

            if ($application->cover_letter) {
                $cover = mb_substr($application->cover_letter, 0, 200);
                $text .= "\n✉️ <i>{$cover}</i>\n";
            }

            $text .= "\n#GuroJobs #NewCandidate";

            // Кнопки
            $buttons = [];
            $buttons[] = [['text' => '👀 View Candidate', 'url' => $jobUrl . '?app=' . $application->id]];
            if ($resumeUrl) {
                $buttons[] = [['text' => '📄 Download Resume', 'url' => $resumeUrl]];
            }
            $buttons[] = [['text' => '📋 All Applications', 'url' => config('app.url') . '/employer/applications']];

            $telegram->sendMessageWithButtons($employer->telegram_id, $text, $buttons);

            // Записываем что отправили в Telegram
            GuroNotification::create([
                'user_id' => $employer->id,
                'type' => 'new_application',
                'title' => "Telegram: New candidate for \"{$jobTitle}\"",
                'body' => "Sent to Telegram @{$employer->telegram_username}",
                'data' => [
                    'job_id' => $job->id,
                    'application_id' => $application->id,
                    'candidate_id' => $candidate->id,
                    'telegram_sent' => true,
                ],
                'channel' => 'telegram',
                'created_at' => now(),
            ]);

            Log::info("Telegram notification sent to employer #{$employer->id} for job #{$job->id}");

        } catch (\Exception $e) {
            Log::error("Telegram notification failed for employer #{$employer->id}: {$e->getMessage()}");
        }
    }

    /**
     * Проверить, может ли рекрутер получать Telegram-уведомления.
     */
    public static function canReceiveTelegramNotifications(User $user): bool
    {
        if (!$user->isEmployer()) return false;
        if (empty($user->telegram_id)) return false;

        $plan = $user->currentPlan();
        return in_array($plan, self::TELEGRAM_PLANS);
    }
}
