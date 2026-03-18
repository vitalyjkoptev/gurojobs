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
    public function execute(array $intent, User $user): array
    {
        return match ($intent['intent']) {
            'stats.today' => $this->statsToday(),
            'stats.period' => $this->statsPeriod($intent['params']),
            'jobs.list' => $this->jobsList($intent['params']),
            'jobs.create' => $this->jobsCreate($intent['params'], $user),
            'jobs.update' => $this->jobsUpdate($intent['params'], $user),
            'users.list' => $this->usersList($intent['params']),
            'users.block' => $this->usersBlock($intent['params'], $user),
            'applications.list' => $this->applicationsList($intent['params']),
            'payments.status' => $this->paymentsStatus($intent['params']),
            'search' => $this->search($intent['params']),
            'report.generate' => $this->reportGenerate($intent['params']),
            'navigation' => $this->navigation($intent['params']),
            default => $this->unknown($intent),
        };
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
            'response' => sprintf(
                "Today's stats: %d new jobs, %d applications, %d new users, %d job views, $%s revenue.",
                $data['new_jobs'], $data['new_applications'], $data['new_users'],
                $data['job_views'], number_format($data['revenue'], 2)
            ),
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
            'response' => sprintf(
                "Stats for last %s: %d new jobs, %d applications, %d new users, $%s revenue.",
                $period, $data['new_jobs'], $data['new_applications'],
                $data['new_users'], number_format($data['revenue'], 2)
            ),
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
            'response' => sprintf("Found %d active jobs. Top results: %s",
                $jobs->count(),
                $jobs->pluck('title')->implode(', ')
            ),
            'data' => $jobs->toArray(),
            'action' => 'jobs.listed',
        ];
    }

    protected function jobsCreate(array $params, User $user): array
    {
        return [
            'success' => true,
            'response' => 'Opening job creation form. Please fill in the details.',
            'data' => ['redirect' => '/employer/jobs/create', 'prefill' => $params],
            'action' => 'navigation.redirect',
        ];
    }

    protected function jobsUpdate(array $params, User $user): array
    {
        if (empty($params['id'])) {
            return [
                'success' => false,
                'response' => 'Please specify a job ID. For example: "Pause job #123"',
                'action' => 'jobs.update_failed',
            ];
        }

        $job = Job::find($params['id']);
        if (!$job) {
            return [
                'success' => false,
                'response' => "Job #{$params['id']} not found.",
                'action' => 'jobs.not_found',
            ];
        }

        return [
            'success' => true,
            'response' => "Job #{$params['id']} \"{$job->title}\" found. What would you like to change?",
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
            'response' => sprintf("Found %d users.", $users->count()),
            'data' => $users->toArray(),
            'action' => 'users.listed',
        ];
    }

    protected function usersBlock(array $params, User $user): array
    {
        return [
            'success' => false,
            'response' => 'Blocking users requires confirmation. Please confirm: "Yes, block user #ID"',
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
            'response' => sprintf("You have %d pending applications.", $count),
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
            'response' => sprintf(
                "Revenue this %s: $%s. Pending payments: $%s.",
                $period, number_format($revenue, 2), number_format($pending, 2)
            ),
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
                'response' => 'What would you like to search for?',
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
            'response' => sprintf("Found %d results for \"%s\".", $jobs->count(), $query),
            'data' => $jobs->toArray(),
            'action' => 'search.results',
        ];
    }

    protected function reportGenerate(array $params): array
    {
        return [
            'success' => true,
            'response' => 'Report generation started. You will be notified when it\'s ready.',
            'data' => ['redirect' => '/admin/reports'],
            'action' => 'report.generating',
        ];
    }

    protected function navigation(array $params): array
    {
        $routes = [
            'dashboard' => '/admin/dashboard',
            'jobs' => '/admin/jobs',
            'users' => '/admin/users',
            'employers' => '/admin/companies',
            'payments' => '/admin/payments',
            'analytics' => '/admin/analytics',
            'settings' => '/admin/settings',
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
            'response' => $target ? "Navigating to {$target}" : 'Where would you like to go? Available: dashboard, jobs, users, employers, payments, analytics, settings.',
            'data' => ['redirect' => $target],
            'action' => $target ? 'navigation.redirect' : 'navigation.unknown',
        ];
    }

    protected function unknown(array $intent): array
    {
        return [
            'success' => false,
            'response' => "I didn't understand that command. Try: \"Show today's stats\", \"List active jobs\", \"Search CMO\", \"Revenue this month\".",
            'action' => 'unknown',
        ];
    }
}
