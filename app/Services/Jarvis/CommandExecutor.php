<?php

namespace App\Services\Jarvis;

use App\Enums\ApplicationStatus;
use App\Models\Company;
use App\Models\Job;
use App\Models\JobApplication;
use App\Models\JobView;
use App\Models\Payment;
use App\Models\User;
use Illuminate\Support\Carbon;

class CommandExecutor
{
    protected string $lang = 'en';

    protected array $translations = [
        'en' => [
            'greeting' => "Hello! I'm Jarvis, your AI assistant. I can show statistics, manage jobs, search vacancies, navigate screens, and more. Just ask!",
            'help' => "I can help with:\n- Statistics: \"Show today's stats\", \"Revenue this month\"\n- Jobs: \"List active jobs\", \"Search CMO\", \"Post new job\"\n- Users: \"Show users\", \"List candidates\"\n- Applications: \"Pending applications\"\n- Navigation: \"Go to dashboard\", \"Open settings\"\n- Profile: \"My profile\", \"My CV\"\nTry voice or text!",
            'stats_today' => "Today's stats: %d new jobs, %d applications, %d new users, %d job views, $%s revenue.",
            'stats_period' => "Stats for last %s: %d new jobs, %d applications, %d new users, $%s revenue.",
            'jobs_found' => "Found %d active jobs. Top results: %s",
            'jobs_create' => "Opening job creation form. Please fill in the details.",
            'job_not_found' => "Job #%d not found.",
            'job_specify_id' => 'Please specify a job ID. For example: "Pause job #123"',
            'job_found' => 'Job #%d "%s" found. What would you like to change?',
            'users_found' => "Found %d users.",
            'block_confirm' => 'Blocking users requires confirmation. Please confirm: "Yes, block user #ID"',
            'apps_pending' => "You have %d pending applications.",
            'revenue' => "Revenue this %s: $%s. Pending payments: $%s.",
            'search_empty' => "What would you like to search for?",
            'search_results' => 'Found %d results for "%s".',
            'report_started' => "Report generation started. You will be notified when it's ready.",
            'nav_where' => "Where would you like to go? Available: dashboard, jobs, users, employers, payments, analytics, settings.",
            'nav_going' => "Navigating to %s",
            'unknown' => "I didn't understand that command. Try: \"Show today's stats\", \"List active jobs\", \"Search CMO\", \"Revenue this month\".",
        ],
        'ru' => [
            'stats_today' => "Статистика за сегодня: %d новых вакансий, %d откликов, %d новых юзеров, %d просмотров, $%s доход.",
            'greeting' => "Привет! Я Джарвис, ваш AI-ассистент. Могу показать статистику, управлять вакансиями, искать позиции, навигировать по экранам и многое другое. Просто скажите!",
            'help' => "Я могу помочь с:\n- Статистика: \"Статистика\", \"Доход за месяц\"\n- Вакансии: \"Покажи вакансии\", \"Найти CMO\", \"Создать вакансию\"\n- Юзеры: \"Пользователи\", \"Кандидаты\"\n- Отклики: \"Заявки\", \"Отклики\"\n- Навигация: \"Открыть дашборд\", \"Настройки\"\n- Профиль: \"Мой профиль\", \"Моё резюме\"\nГолос или текст!",
            'stats_period' => "Статистика за %s: %d новых вакансий, %d откликов, %d новых юзеров, $%s доход.",
            'jobs_found' => "Найдено %d активных вакансий. Топ: %s",
            'jobs_create' => "Открываю форму создания вакансии. Заполните детали.",
            'job_not_found' => "Вакансия #%d не найдена.",
            'job_specify_id' => 'Укажите ID вакансии. Например: "Пауза вакансия #123"',
            'job_found' => 'Вакансия #%d "%s" найдена. Что хотите изменить?',
            'users_found' => "Найдено %d пользователей.",
            'block_confirm' => 'Блокировка требует подтверждения. Подтвердите: "Да, заблокировать #ID"',
            'apps_pending' => "У вас %d ожидающих откликов.",
            'revenue' => "Доход за %s: $%s. Ожидающие платежи: $%s.",
            'search_empty' => "Что вы хотите найти?",
            'search_results' => 'Найдено %d результатов по запросу "%s".',
            'report_started' => "Генерация отчёта запущена. Вы получите уведомление.",
            'nav_where' => "Куда перейти? Доступно: дашборд, вакансии, юзеры, работодатели, платежи, аналитика, настройки.",
            'nav_going' => "Перехожу на %s",
            'unknown' => "Не понял команду. Попробуйте: \"Статистика\", \"Покажи вакансии\", \"Найти CMO\", \"Доход за месяц\".",
        ],
        'uk' => [
            'stats_today' => "Статистика за сьогодні: %d нових вакансій, %d відгуків, %d нових юзерів, %d переглядів, $%s дохід.",
            'stats_period' => "Статистика за %s: %d нових вакансій, %d відгуків, %d нових юзерів, $%s дохід.",
            'greeting' => "Привіт! Я Джарвіс, ваш AI-асистент. Можу показати статистику, керувати вакансіями, шукати позиції, навігувати по екранах та багато іншого. Просто скажіть!",
            'help' => "Я можу допомогти з:\n- Статистика: \"Статистика\", \"Дохід за місяць\"\n- Вакансії: \"Покажи вакансії\", \"Знайти CMO\", \"Створити вакансію\"\n- Юзери: \"Користувачі\", \"Кандидати\"\n- Відгуки: \"Заявки\", \"Відгуки\"\n- Навігація: \"Відкрити дашборд\", \"Налаштування\"\n- Профіль: \"Мій профіль\", \"Моє резюме\"\nГолос або текст!",
            'jobs_found' => "Знайдено %d активних вакансій. Топ: %s",
            'jobs_create' => "Відкриваю форму створення вакансії. Заповніть деталі.",
            'job_not_found' => "Вакансію #%d не знайдено.",
            'job_specify_id' => 'Вкажіть ID вакансії. Наприклад: "Пауза вакансія #123"',
            'job_found' => 'Вакансію #%d "%s" знайдено. Що хочете змінити?',
            'users_found' => "Знайдено %d користувачів.",
            'block_confirm' => 'Блокування потребує підтвердження. Підтвердіть: "Так, заблокувати #ID"',
            'apps_pending' => "У вас %d очікуючих відгуків.",
            'revenue' => "Дохід за %s: $%s. Очікуючі платежі: $%s.",
            'search_empty' => "Що ви хочете знайти?",
            'search_results' => 'Знайдено %d результатів за запитом "%s".',
            'report_started' => "Генерацію звіту запущено. Ви отримаєте сповіщення.",
            'nav_where' => "Куди перейти? Доступно: дашборд, вакансії, юзери, роботодавці, платежі, аналітика, налаштування.",
            'nav_going' => "Переходжу на %s",
            'unknown' => "Не зрозумів команду. Спробуйте: \"Статистика\", \"Покажи вакансії\", \"Знайти CMO\", \"Дохід за місяць\".",
        ],
    ];

    protected function t(string $key, ...$args): string
    {
        $template = $this->translations[$this->lang][$key] ?? $this->translations['en'][$key] ?? $key;
        return $args ? sprintf($template, ...$args) : $template;
    }

    public function execute(array $intent, User $user): array
    {
        $this->lang = $intent['lang'] ?? 'en';

        return match ($intent['intent']) {
            'greeting' => $this->greeting(),
            'help' => $this->help(),
            'stats.today' => $this->statsToday(),
            'stats.period' => $this->statsPeriod($intent['params']),
            'jobs.list' => $this->jobsList($intent['params']),
            'jobs.create' => $this->jobsCreate($intent['params'], $user),
            'jobs.update' => $this->jobsUpdate($intent['params'], $user),
            'users.list' => $this->usersList($intent['params']),
            'users.block' => $this->usersBlock($intent['params'], $user),
            'applications.list' => $this->applicationsList($intent['params']),
            'payments.status' => $this->paymentsStatus($intent['params']),
            'profile.show' => ['success' => true, 'response' => $this->t('nav_going', '/profile'), 'data' => ['redirect' => '/profile'], 'action' => 'navigation.redirect'],
            'cv.show' => ['success' => true, 'response' => $this->t('nav_going', '/cv'), 'data' => ['redirect' => '/candidate/resume'], 'action' => 'navigation.redirect'],
            'settings.show' => ['success' => true, 'response' => $this->t('nav_going', '/settings'), 'data' => ['redirect' => '/settings'], 'action' => 'navigation.redirect'],
            'search' => $this->search($intent['params']),
            'report.generate' => $this->reportGenerate($intent['params']),
            'navigation' => $this->navigation($intent['params']),
            default => $this->unknown($intent),
        };
    }

    protected function greeting(): array
    {
        return ['success' => true, 'response' => $this->t('greeting'), 'action' => 'greeting'];
    }

    protected function help(): array
    {
        return ['success' => true, 'response' => $this->t('help'), 'action' => 'help'];
    }

    protected function statsToday(): array
    {
        $today = Carbon::today();

        $data = [
            'new_jobs' => Job::whereDate('created_at', $today)->count(),
            'new_applications' => JobApplication::whereDate('created_at', $today)->count(),
            'new_users' => User::whereDate('created_at', $today)->count(),
            'job_views' => JobView::whereDate('created_at', $today)->count(),
            'revenue' => Payment::whereDate('created_at', $today)->where('status', 'completed')->sum('amount'),
        ];

        return [
            'success' => true,
            'response' => $this->t('stats_today', $data['new_jobs'], $data['new_applications'], $data['new_users'], $data['job_views'], number_format($data['revenue'], 2)),
            'data' => $data,
            'action' => 'stats.displayed',
        ];
    }

    protected function statsPeriod(array $params): array
    {
        $period = $params['period'] ?? 'week';
        $startDate = match ($period) {
            'week' => Carbon::now()->subWeek(),
            'month' => Carbon::now()->subMonth(),
            'year' => Carbon::now()->subYear(),
            default => Carbon::now()->subWeek(),
        };

        $data = [
            'period' => $period,
            'new_jobs' => Job::where('created_at', '>=', $startDate)->count(),
            'new_applications' => JobApplication::where('created_at', '>=', $startDate)->count(),
            'new_users' => User::where('created_at', '>=', $startDate)->count(),
            'revenue' => Payment::where('created_at', '>=', $startDate)->where('status', 'completed')->sum('amount'),
        ];

        return [
            'success' => true,
            'response' => $this->t('stats_period', $period, $data['new_jobs'], $data['new_applications'], $data['new_users'], number_format($data['revenue'], 2)),
            'data' => $data,
            'action' => 'stats.displayed',
        ];
    }

    protected function jobsList(array $params): array
    {
        $query = Job::where('status', 'active')->latest();

        if (!empty($params['experience_level'])) {
            $query->where('experience_level', $params['experience_level']);
        }

        if (!empty($params['query'])) {
            $q = $params['query'];
            $query->where(function ($qb) use ($q) {
                $qb->where('title', 'like', "%{$q}%")
                    ->orWhere('description', 'like', "%{$q}%");
            });
        }

        $jobs = $query->limit(10)->get(['id', 'title', 'experience_level', 'views_count', 'applications_count']);

        return [
            'success' => true,
            'response' => $this->t('jobs_found', $jobs->count(), $jobs->pluck('title')->implode(', ')),
            'data' => $jobs->toArray(),
            'action' => 'jobs.listed',
        ];
    }

    protected function jobsCreate(array $params, User $user): array
    {
        return [
            'success' => true,
            'response' => $this->t('jobs_create'),
            'data' => ['redirect' => '/employer/jobs/create', 'prefill' => $params],
            'action' => 'navigation.redirect',
        ];
    }

    protected function jobsUpdate(array $params, User $user): array
    {
        if (empty($params['id'])) {
            return [
                'success' => false,
                'response' => $this->t('job_specify_id'),
                'action' => 'jobs.update_failed',
            ];
        }

        $job = Job::find($params['id']);
        if (!$job) {
            return [
                'success' => false,
                'response' => $this->t('job_not_found', $params['id']),
                'action' => 'jobs.not_found',
            ];
        }

        return [
            'success' => true,
            'response' => $this->t('job_found', $params['id'], $job->title),
            'data' => $job->toArray(),
            'action' => 'jobs.update_ready',
        ];
    }

    protected function usersList(array $params): array
    {
        $query = User::latest();

        if (!empty($params['query'])) {
            $q = $params['query'];
            $query->where('name', 'like', "%{$q}%")->orWhere('email', 'like', "%{$q}%");
        }

        $users = $query->limit(10)->get(['id', 'name', 'email', 'role', 'created_at']);

        return [
            'success' => true,
            'response' => $this->t('users_found', $users->count()),
            'data' => $users->toArray(),
            'action' => 'users.listed',
        ];
    }

    protected function usersBlock(array $params, User $user): array
    {
        return [
            'success' => false,
            'response' => $this->t('block_confirm'),
            'data' => $params,
            'action' => 'users.block_confirm',
        ];
    }

    protected function applicationsList(array $params): array
    {
        $query = JobApplication::where('status', ApplicationStatus::Pending->value)->latest();
        $count = $query->count();
        $applications = $query->limit(10)->with(['job:id,title'])->get();

        return [
            'success' => true,
            'response' => $this->t('apps_pending', $count),
            'data' => $applications->toArray(),
            'action' => 'applications.listed',
        ];
    }

    protected function paymentsStatus(array $params): array
    {
        $period = $params['period'] ?? 'month';
        $startDate = match ($period) {
            'week' => Carbon::now()->subWeek(),
            'month' => Carbon::now()->subMonth(),
            'year' => Carbon::now()->subYear(),
            default => Carbon::now()->subMonth(),
        };

        $revenue = Payment::where('created_at', '>=', $startDate)
            ->where('status', 'completed')
            ->sum('amount');

        $pending = Payment::where('status', 'pending')->sum('amount');

        return [
            'success' => true,
            'response' => $this->t('revenue', $period, number_format($revenue, 2), number_format($pending, 2)),
            'data' => ['revenue' => $revenue, 'pending' => $pending, 'period' => $period],
            'action' => 'payments.displayed',
        ];
    }

    protected function search(array $params): array
    {
        $query = $params['query'] ?? '';
        if (empty($query)) {
            return [
                'success' => false,
                'response' => $this->t('search_empty'),
                'action' => 'search.empty',
            ];
        }

        $jobs = Job::where('status', 'active')
            ->where(function ($qb) use ($query) {
                $qb->where('title', 'like', "%{$query}%")
                    ->orWhere('description', 'like', "%{$query}%")
                    ->orWhereJsonContains('tags', $query);
            })
            ->limit(10)
            ->get(['id', 'title', 'experience_level', 'work_mode', 'salary_min', 'salary_max']);

        return [
            'success' => true,
            'response' => $this->t('search_results', $jobs->count(), $query),
            'data' => $jobs->toArray(),
            'action' => 'search.results',
        ];
    }

    protected function reportGenerate(array $params): array
    {
        return [
            'success' => true,
            'response' => $this->t('report_started'),
            'data' => ['redirect' => '/admin/reports'],
            'action' => 'report.generating',
        ];
    }

    protected function navigation(array $params): array
    {
        $routes = [
            'dashboard' => '/admin/dashboard', 'дашборд' => '/admin/dashboard', 'головна' => '/admin/dashboard',
            'jobs' => '/admin/jobs', 'вакансии' => '/admin/jobs', 'вакансії' => '/admin/jobs',
            'users' => '/admin/users', 'юзеры' => '/admin/users', 'користувачі' => '/admin/users',
            'employers' => '/admin/companies', 'работодатели' => '/admin/companies', 'роботодавці' => '/admin/companies',
            'payments' => '/admin/payments', 'платежи' => '/admin/payments', 'платежі' => '/admin/payments',
            'analytics' => '/admin/analytics', 'аналитика' => '/admin/analytics', 'аналітика' => '/admin/analytics',
            'settings' => '/admin/settings', 'настройки' => '/admin/settings', 'налаштування' => '/admin/settings',
        ];

        $target = null;
        foreach ($routes as $keyword => $route) {
            if (!empty($params['query']) && str_contains(mb_strtolower($params['query']), $keyword)) {
                $target = $route;
                break;
            }
        }

        if (!empty($params['id'])) {
            $target = "/admin/jobs/{$params['id']}";
        }

        return [
            'success' => (bool) $target,
            'response' => $target ? $this->t('nav_going', $target) : $this->t('nav_where'),
            'data' => ['redirect' => $target],
            'action' => $target ? 'navigation.redirect' : 'navigation.unknown',
        ];
    }

    protected function unknown(array $intent): array
    {
        return [
            'success' => false,
            'response' => $this->t('unknown'),
            'action' => 'unknown',
        ];
    }
}
