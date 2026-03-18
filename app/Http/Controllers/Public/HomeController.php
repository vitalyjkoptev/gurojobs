<?php

namespace App\Http\Controllers\Public;

use App\Http\Controllers\Controller;
use App\Models\Job;
use App\Models\JobCategory;
use Illuminate\View\View;

class HomeController extends Controller
{
    public function index(): View
    {
        $categories = JobCategory::orderBy('sort_order')
            ->get()
            ->map(function ($cat) {
                $cat->jobs_count = $cat->activeJobsCount();
                return $cat;
            });

        $featuredJobs = Job::active()
            ->featured()
            ->with(['company:id,name,slug,logo'])
            ->limit(6)
            ->latest()
            ->get();

        $latestJobs = Job::active()
            ->with(['company:id,name,slug,logo'])
            ->latest()
            ->limit(6)
            ->get();

        return view('public.home', compact('categories', 'featuredJobs', 'latestJobs'));
    }
}
