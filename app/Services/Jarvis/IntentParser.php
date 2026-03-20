<?php

namespace App\Services\Jarvis;

use Illuminate\Support\Facades\Http;

class IntentParser
{
    protected array $intents = [
        // EN / RU / UK
        'greeting' => ['hello', 'hi jarvis', 'hey jarvis', 'good morning', 'good evening', 'привет', 'здравствуй', 'добрый день', 'доброе утро', 'добрий день', 'привіт', 'вітаю'],
        'help' => ['help', 'what can you do', 'commands', 'помощь', 'что ты умеешь', 'что можешь', 'команды', 'допомога', 'що ти вмієш', 'команди'],
        'stats.today' => ['stats today', 'today stats', 'show today', 'statistics', 'how many today', 'today\'s numbers', 'today\'s stats', 'daily stats', 'сколько сегодня', 'статистика', 'стата', 'покажи стату', 'статистика сьогодні', 'скільки сьогодні'],
        'stats.period' => ['stats for', 'last week', 'last month', 'monthly report', 'weekly', 'this week', 'this month', 'отчет за', 'за неделю', 'за месяц', 'звіт за', 'за тиждень', 'за місяць'],
        'jobs.list' => ['show jobs', 'list jobs', 'active jobs', 'vacancies', 'all jobs', 'вакансии', 'список вакансий', 'покажи вакансии', 'вакансії', 'покажи вакансії', 'список вакансій'],
        'jobs.create' => ['post job', 'create job', 'new vacancy', 'add job', 'new job', 'создать вакансию', 'новая вакансия', 'створити вакансію', 'нова вакансія'],
        'jobs.update' => ['pause job', 'close job', 'update job', 'edit job', 'изменить вакансию', 'закрыть вакансию', 'змінити вакансію', 'закрити вакансію'],
        'users.list' => ['show users', 'list candidates', 'list employers', 'new users', 'all users', 'пользователи', 'кандидаты', 'работодатели', 'користувачі', 'кандидати', 'роботодавці'],
        'users.block' => ['block user', 'suspend', 'ban user', 'заблокировать', 'заблокувати'],
        'applications.list' => ['applications', 'new applications', 'pending applications', 'заявки', 'отклики', 'відгуки', 'мои отклики', 'мої відгуки'],
        'payments.status' => ['revenue', 'payments', 'income', 'money', 'earnings', 'выручка', 'платежи', 'доход', 'виручка', 'платежі', 'дохід'],
        'profile.show' => ['my profile', 'show profile', 'мой профиль', 'покажи профиль', 'мій профіль'],
        'cv.show' => ['my cv', 'my resume', 'show cv', 'моё резюме', 'покажи резюме', 'моє резюме'],
        'settings.show' => ['settings', 'настройки', 'налаштування'],
        'search' => ['find', 'search', 'look for', 'искать', 'найти', 'шукати', 'знайти'],
        'report.generate' => ['generate report', 'export', 'download report', 'create report', 'сгенерировать отчет', 'экспорт', 'згенерувати звіт', 'експорт'],
        'navigation' => ['go to', 'open page', 'navigate', 'перейти', 'открыть', 'відкрити'],
    ];

    public function parse(string $command): array
    {
        $commandLower = mb_strtolower($command);
        $lang = $this->detectLanguage($command);

        // Try local pattern matching first
        foreach ($this->intents as $intent => $patterns) {
            foreach ($patterns as $pattern) {
                if (str_contains($commandLower, $pattern)) {
                    return [
                        'intent' => $intent,
                        'command' => $command,
                        'params' => $this->extractParams($intent, $command),
                        'confidence' => 'local',
                        'lang' => $lang,
                    ];
                }
            }
        }

        // Fallback to AI parsing if configured
        if (config('gurojobs.jarvis.ai_enabled')) {
            $result = $this->parseWithAI($command);
            $result['lang'] = $lang;
            return $result;
        }

        return [
            'intent' => 'unknown',
            'command' => $command,
            'params' => [],
            'confidence' => 'none',
            'lang' => $lang,
        ];
    }

    protected function detectLanguage(string $text): string
    {
        if (preg_match('/[а-яёА-ЯЁ]/u', $text)) {
            return preg_match('/[іїєґІЇЄҐ]/u', $text) ? 'uk' : 'ru';
        }
        return 'en';
    }

    protected function extractParams(string $intent, string $command): array
    {
        $params = [];

        // Extract numbers (IDs)
        if (preg_match('/#?(\d+)/', $command, $matches)) {
            $params['id'] = (int) $matches[1];
        }

        // Extract quoted strings
        if (preg_match('/"([^"]+)"/', $command, $matches)) {
            $params['query'] = $matches[1];
        }

        // Extract period (EN/RU/UK)
        if (preg_match('/(?:last|this|за)\s+(week|month|year|неделю|месяц|год|тиждень|місяць|рік)/iu', $command, $matches)) {
            $periodMap = [
                'week' => 'week', 'неделю' => 'week', 'тиждень' => 'week',
                'month' => 'month', 'месяц' => 'month', 'місяць' => 'month',
                'year' => 'year', 'год' => 'year', 'рік' => 'year',
            ];
            $params['period'] = $periodMap[mb_strtolower($matches[1])] ?? $matches[1];
        }

        // Extract experience level
        foreach (['c-level', 'head', 'senior', 'middle', 'junior'] as $level) {
            if (str_contains(mb_strtolower($command), $level)) {
                $params['experience_level'] = $level;
                break;
            }
        }

        // Extract search query after keywords
        if (str_starts_with($intent, 'search') || str_starts_with($intent, 'jobs.list')) {
            $cleanedCommand = preg_replace('/^(find|search|look for|искать|найти|шукати|знайти)\s+/iu', '', $command);
            $params['query'] = trim($cleanedCommand);
        }

        return $params;
    }

    protected function getSystemPrompt(): string
    {
        return <<<'PROMPT'
You are Jarvis, the AI master agent for GURO JOBS — an iGaming job portal.
You understand commands in English, Russian (русский), and Ukrainian (українська).
Respond in the SAME language as the user's command.

## Platform Overview
GURO JOBS is a job portal for the iGaming industry (gambling, betting, crypto, nutra, dating, e-commerce, fintech).
3 roles: admin, employer, candidate. Each has different screens and capabilities.

## ALL Available Screens & Features

### ADMIN screens (boss mode):
- Dashboard: KPI stats (total users, jobs, companies, new today, revenue, reports)
- Users: list/search/filter users by role (candidate/employer/admin), status (active/pending/banned), ban/unban
- Jobs: list/moderate/approve/reject/feature jobs, filter by status (active/paused/closed/draft)
- Chat: conversations with users
- Admin Panel: settings, security, database tools, verification, subscription management
- Analytics: platform-wide analytics, charts, trends
- Payments: view payments, revenue reports
- Reports: user reports/complaints management

### EMPLOYER screens:
- Dashboard: active jobs count, applications, new today, job views, hired count
- My Jobs: list employer's jobs, post new job, edit/pause/close jobs
- Candidates: view applications, change status (new/reviewed/interview/hired/rejected), view CV
- Company Profile: edit company info, logo, description
- Subscription: billing, payment plans for employers (Starter $49/mo, Business $149/mo, Enterprise $499/mo)
- Chat: communicate with candidates

### CANDIDATE screens (ALL FREE for candidates, premium features coming later):
- Dashboard: find jobs, popular categories (Gambling, Betting, Crypto, Nutra, Dating, E-commerce, FinTech, Other)
- Find Jobs: search by keyword, filter (salary, experience, remote/office/hybrid, verticals, geo, english level)
- My Applications: track applications (sent/viewed/interview/offer/rejected), organizer with meetings
- Profile: edit personal info, skills, experience
- CV/Resume: upload CV (PDF), CV builder, preview, download PDF
- Saved Jobs: bookmarked vacancies
- Connections: connect messengers (Telegram, WhatsApp, Viber, Signal, Email) and social networks (LinkedIn, GitHub, Twitter, Facebook, Instagram, Discord)
- Billing: FREE for candidates. Paid plans only for employers.
- Workspace: notes, drafts, integrations (Notion, Obsidian, Google Drive, Google Sheets)
- Chat: communicate with employers
- Settings: language (EN/RU/UK), dark mode, notifications, help
- Notifications: job alerts, application updates

## Available intents:
- stats.today — today's statistics
- stats.period — stats for week/month/year
- jobs.list — list/show jobs (with optional filters)
- jobs.create — create/post new job
- jobs.update — edit/pause/close/delete a job
- users.list — list/show users (with optional role/status filter)
- users.block — block/ban a user
- users.unblock — unblock/unban a user
- applications.list — list applications (pending/all)
- applications.update — change application status
- payments.status — revenue, payments info
- search — search jobs, users, companies
- report.generate — generate analytics report
- navigation — navigate to a screen/page
- profile.show — show user profile
- profile.update — update profile info
- company.show — show company profile
- company.update — update company info
- cv.show — show CV/resume
- cv.create — create/build CV
- settings.show — open settings
- help — help/what can you do
- greeting — hello/hi/привет
- unknown — cannot understand

Parse the user's command and return JSON: {"intent":"...","params":{...},"response":"..."}
- intent: one of the intents above
- params: extracted parameters (id, query, role, status, period, etc.)
- response: a helpful response in the user's language. If intent is greeting or help, provide a friendly answer describing what you can do. For data intents, just describe what you'll do.

Respond ONLY with valid JSON, no markdown.
PROMPT;
    }

    protected function parseWithAI(string $command): array
    {
        $response = Http::withHeaders([
            'x-api-key' => config('gurojobs.jarvis.api_key'),
            'Content-Type' => 'application/json',
            'anthropic-version' => '2023-06-01',
        ])->timeout(15)->post('https://api.anthropic.com/v1/messages', [
            'model' => config('gurojobs.jarvis.model', 'claude-sonnet-4-6'),
            'max_tokens' => 500,
            'system' => $this->getSystemPrompt(),
            'messages' => [
                ['role' => 'user', 'content' => $command],
            ],
        ]);

        if ($response->successful()) {
            $content = $response->json('content.0.text', '{}');
            // Strip markdown code fences if present
            $content = preg_replace('/^```(?:json)?\s*|\s*```$/s', '', trim($content));
            $parsed = json_decode($content, true) ?? [];

            return [
                'intent' => $parsed['intent'] ?? 'unknown',
                'command' => $command,
                'params' => $parsed['params'] ?? [],
                'confidence' => 'ai',
                'ai_response' => $parsed['response'] ?? null,
            ];
        }

        return [
            'intent' => 'unknown',
            'command' => $command,
            'params' => [],
            'confidence' => 'none',
        ];
    }
}
