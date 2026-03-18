<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Job;
use App\Models\Company;
use App\Models\JobApplication;
use App\Models\JobCategory;
use App\Models\Payment;
use App\Models\Subscription;

class WebAdminController extends Controller
{
    public function dashboard()
    {
        $stats = [
            'users' => User::count(),
            'jobs' => Job::where('status', 'active')->count(),
            'companies' => Company::count(),
            'applications' => JobApplication::count(),
        ];

        $recentUsers = User::latest()->take(5)->get();
        $recentJobs = Job::with('company')->latest()->take(5)->get();

        $roleStats = User::selectRaw('role, count(*) as count')
            ->groupBy('role')
            ->pluck('count', 'role')
            ->toArray();

        return view('admin.dashboard', compact('stats', 'recentUsers', 'recentJobs', 'roleStats'));
    }

    public function users()
    {
        $users = User::latest()->paginate(25);
        return view('admin.users', compact('users'));
    }

    public function jobs()
    {
        $jobs = Job::with('company')->latest()->paginate(25);
        return view('admin.jobs', compact('jobs'));
    }

    public function companies()
    {
        $companies = Company::with('owner')->latest()->paginate(25);
        return view('admin.companies', compact('companies'));
    }

    public function applications()
    {
        $applications = JobApplication::with(['job.company', 'candidate'])->latest()->paginate(25);
        return view('admin.applications', compact('applications'));
    }

    public function categories()
    {
        $categories = JobCategory::withCount('jobs')->orderBy('name')->get();
        return view('admin.categories', compact('categories'));
    }

    public function payments()
    {
        $payments = Payment::with('user')->latest()->paginate(25);
        return view('admin.payments', compact('payments'));
    }

    public function subscriptions()
    {
        $subscriptions = Subscription::with(['user', 'company'])->latest()->paginate(25);
        return view('admin.subscriptions', compact('subscriptions'));
    }

    public function settings()
    {
        return view('admin.settings');
    }

    public function faqs()
    {
        return view('admin.faqs');
    }

    public function search()
    {
        $q = request('q');
        $results = [];

        if ($q) {
            $results['users'] = User::where('name', 'like', "%{$q}%")->orWhere('email', 'like', "%{$q}%")->take(5)->get();
            $results['jobs'] = Job::where('title', 'like', "%{$q}%")->with('company')->take(5)->get();
            $results['companies'] = Company::where('name', 'like', "%{$q}%")->take(5)->get();
        }

        return view('admin.search', compact('q', 'results'));
    }

    public function profile()
    {
        $user = auth()->user();
        return view('admin.profile-overview', compact('user'));
    }

    public function profileProjects()
    {
        $user = auth()->user();
        return view('admin.profile-projects', compact('user'));
    }

    public function profileConnections()
    {
        $user = auth()->user();
        $users = User::where('id', '!=', $user->id)->take(20)->get();
        return view('admin.profile-connections', compact('user', 'users'));
    }
}
