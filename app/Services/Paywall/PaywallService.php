<?php

namespace App\Services\Paywall;

use App\Models\User;

class PaywallService
{
    /**
     * Стратегия пейволла:
     *
     * FREE план (и employer и candidate):
     * - Видят УРЕЗАННОЕ резюме / вакансию (без контактов, email, phone, telegram, links)
     * - НЕ могут отправлять сообщения
     * - НЕ могут открывать диалог
     * - НЕ могут отправлять контакты (email, phone, telegram) в чате
     * - НЕ могут отправлять ссылки (zoom.us, meet.google.com, teams.microsoft.com и т.д.)
     * - Видят кнопку "Upgrade to see full profile"
     *
     * STARTER+ (любой платный):
     * - Полное резюме / вакансия
     * - Могут писать сообщения
     * - Могут отправлять контакты
     * - Могут отправлять ссылки
     */

    // Запрещённые паттерны в сообщениях для FREE плана
    private const BLOCKED_LINK_PATTERNS = [
        'zoom.us',
        'meet.google.com',
        'teams.microsoft.com',
        'calendly.com',
        'whereby.com',
        'skype.com',
        'discord.gg',
        'https://',
        'http://',
        'www.',
    ];

    private const BLOCKED_CONTACT_PATTERNS = [
        '/[\w.+-]+@[\w-]+\.[\w.]+/',       // email
        '/\+?\d[\d\s\-()]{7,}/',            // phone number
        '/@\w{3,}/',                         // telegram handle @username
    ];

    /**
     * Может ли пользователь видеть полный профиль/резюме/вакансию?
     *
     * Кандидат — видит вакансии бесплатно, приложение бесплатное.
     * Employer — платит за просмотр полных резюме кандидатов.
     */
    public function canViewFullProfile(User $user): bool
    {
        if ($user->isAdmin()) {
            return true;
        }

        // Кандидат видит вакансии бесплатно
        if ($user->isCandidate()) {
            return true;
        }

        // Employer платит за просмотр резюме
        return $user->hasActivePlan();
    }

    /**
     * Может ли пользователь отправлять сообщения?
     *
     * Кандидат — может писать бесплатно (но нельзя ссылки/контакты без платного).
     * Employer — платит.
     */
    public function canSendMessages(User $user): bool
    {
        if ($user->isAdmin()) {
            return true;
        }

        // Кандидат может писать, но контент фильтруется
        if ($user->isCandidate()) {
            return true;
        }

        return $user->hasActivePlan();
    }

    /**
     * Может ли пользователь открывать диалоги?
     */
    public function canStartConversation(User $user): bool
    {
        return $this->canSendMessages($user);
    }

    /**
     * Проверить текст сообщения на запрещённый контент (для FREE).
     * Возвращает null если ОК, или причину блокировки.
     */
    public function checkMessageContent(User $user, string $body): ?string
    {
        if ($user->isAdmin() || $user->hasActivePlan()) {
            return null; // без ограничений
        }

        // Проверяем ссылки
        foreach (self::BLOCKED_LINK_PATTERNS as $pattern) {
            if (stripos($body, $pattern) !== false) {
                return 'contains_link';
            }
        }

        // Проверяем контактные данные
        foreach (self::BLOCKED_CONTACT_PATTERNS as $pattern) {
            if (preg_match($pattern, $body)) {
                return 'contains_contact';
            }
        }

        return null;
    }

    /**
     * Отфильтровать данные профиля/резюме для FREE плана.
     * Убирает контакты, телефон, email, ссылки.
     */
    public function filterProfileData(array $data, User $viewer): array
    {
        if ($viewer->isAdmin() || $viewer->hasActivePlan()) {
            return $data; // полные данные
        }

        // Скрываем контакты
        $hidden = '*** Upgrade to view ***';

        if (isset($data['email'])) {
            $data['email'] = $hidden;
        }
        if (isset($data['phone'])) {
            $data['phone'] = $hidden;
        }
        if (isset($data['telegram'])) {
            $data['telegram'] = $hidden;
        }
        if (isset($data['linkedin'])) {
            $data['linkedin'] = $hidden;
        }
        if (isset($data['github'])) {
            $data['github'] = $hidden;
        }
        if (isset($data['portfolio'])) {
            $data['portfolio'] = $hidden;
        }
        if (isset($data['website'])) {
            $data['website'] = $hidden;
        }

        // Если это resume_data — скрываем и внутри
        if (isset($data['personal'])) {
            $data['personal']['email'] = $hidden;
            $data['personal']['phone'] = $hidden;
        }
        if (isset($data['links'])) {
            $data['links'] = array_map(fn() => $hidden, $data['links']);
        }

        // Урезаем описание / summary до первых 200 символов
        if (isset($data['bio']) && strlen($data['bio']) > 200) {
            $data['bio'] = mb_substr($data['bio'], 0, 200) . '... [Upgrade to see full]';
        }
        if (isset($data['description']) && strlen($data['description']) > 200) {
            $data['description'] = mb_substr($data['description'], 0, 200) . '... [Upgrade to see full]';
        }
        if (isset($data['personal']['summary']) && strlen($data['personal']['summary']) > 200) {
            $data['personal']['summary'] = mb_substr($data['personal']['summary'], 0, 200) . '... [Upgrade to see full]';
        }

        $data['_paywall'] = true;
        $data['_paywall_message'] = 'Upgrade your plan to view full profile and contact details.';

        return $data;
    }

    /**
     * Отфильтровать данные вакансии для FREE кандидата.
     */
    public function filterJobData(array $data, User $viewer): array
    {
        if ($viewer->isAdmin() || $viewer->hasActivePlan()) {
            return $data;
        }

        // Показываем основное: title, company, location, salary_range, experience_level
        // Скрываем: полное description, requirements, контакты компании
        if (isset($data['requirements']) && strlen($data['requirements']) > 150) {
            $data['requirements'] = mb_substr($data['requirements'], 0, 150) . '... [Upgrade to see full]';
        }

        // company contacts hidden
        if (isset($data['company'])) {
            unset($data['company']['website']);
            unset($data['company']['telegram_channel']);
        }

        $data['_paywall'] = true;
        $data['_paywall_message'] = 'Upgrade your plan to view full job description.';

        return $data;
    }

    /**
     * Информация о пейволле для фронта.
     */
    public function getPaywallStatus(User $user): array
    {
        $hasPlan = $user->hasActivePlan();

        return [
            'has_active_plan' => $hasPlan,
            'current_plan' => $user->currentPlan(),
            'can_send_messages' => $this->canSendMessages($user),
            'can_view_full_profiles' => $this->canViewFullProfile($user),
            'can_share_contacts' => $hasPlan || $user->isAdmin(),
            'can_share_links' => $hasPlan || $user->isAdmin(),
            'upgrade_url' => '/pricing',
        ];
    }
}
