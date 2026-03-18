<?php

namespace App\Http\Controllers\Public;

use App\Http\Controllers\Controller;
use App\Models\Job;
use App\Models\JobCategory;
use Illuminate\Http\Request;
use Illuminate\View\View;

class JobListController extends Controller
{
    public function index(Request $request): View
    {
        $query = Job::active()->with(['company:id,name,slug,logo,verified', 'category:id,name,slug,icon']);

        if ($q = $request->input('q')) {
            $query->search($q);
        }
        if ($level = $request->input('experience_level')) {
            $query->where('experience_level', $level);
        }
        if ($type = $request->input('job_type')) {
            $query->where('job_type', $type);
        }
        if ($mode = $request->input('work_mode')) {
            $query->where('work_mode', $mode);
        }
        if ($category = $request->input('category')) {
            $query->whereHas('category', fn($qb) => $qb->where('slug', $category));
        }

        $jobs = $query->orderByDesc('is_featured')->latest()->paginate(20);
        $categories = JobCategory::orderBy('sort_order')->get();
        $searchQuery = $request->input('q', '');

        return view('public.jobs', compact('jobs', 'categories', 'searchQuery'));
    }

    public function show(string $slug): View
    {
        $job = Job::where('slug', $slug)->with(['company', 'category'])->firstOrFail();
        $job->incrementViews();

        $relatedJobs = Job::active()
            ->where('id', '!=', $job->id)
            ->where('category_id', $job->category_id)
            ->limit(4)
            ->latest()
            ->get();

        return view('public.job-detail', compact('job', 'relatedJobs'));
    }
}
