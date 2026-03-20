<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Job;
use App\Models\JobCategory;
use App\Models\JobClick;
use App\Models\JobView;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class JobsController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Job::active()->with(['company:id,name,slug,logo,verified,rating_avg,main_office_countries', 'category:id,name,slug,icon']);

        // Keyword search
        if ($q = $request->input('q')) {
            $query->search($q);
        }

        // Filters
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
            $query->whereHas('category', fn($q) => $q->where('slug', $category));
        }
        if ($location = $request->input('location')) {
            $query->where('location', 'like', "%{$location}%");
        }
        if ($salaryMin = $request->input('salary_min')) {
            $query->where('salary_max', '>=', $salaryMin);
        }

        // Candidate blocked countries filter — hide jobs from companies in blocked countries
        $user = $request->user();
        if ($user && $user->isCandidate()) {
            $profile = $user->candidateProfile;
            if ($profile && !empty($profile->blocked_company_countries)) {
                $blocked = $profile->blocked_company_countries;
                $query->whereHas('company', function ($q) use ($blocked) {
                    foreach ($blocked as $country) {
                        $q->where(function ($sub) use ($country) {
                            $sub->where('location', 'not like', "%{$country}%")
                                ->where(function ($inner) use ($country) {
                                    $inner->whereNull('main_office_countries')
                                          ->orWhereRaw('NOT JSON_CONTAINS(main_office_countries, ?)', [json_encode($country)]);
                                });
                        });
                    }
                });
            }
        }

        // Sort
        $sort = $request->input('sort', 'latest');
        $query = match ($sort) {
            'salary' => $query->orderByDesc('salary_max'),
            'views' => $query->orderByDesc('views_count'),
            'oldest' => $query->orderBy('created_at'),
            default => $query->latest(),
        };

        // Featured first
        $query->orderByDesc('is_featured');

        $jobs = $query->paginate($request->input('per_page', 20));

        return response()->json($jobs);
    }

    public function show(string $slug): JsonResponse
    {
        $job = Job::where('slug', $slug)
            ->with(['company', 'category'])
            ->firstOrFail();

        return response()->json(['success' => true, 'data' => $job]);
    }

    public function categories(): JsonResponse
    {
        $categories = JobCategory::orderBy('sort_order')
            ->get()
            ->map(function ($cat) {
                $cat->jobs_count = $cat->activeJobsCount();
                return $cat;
            });

        return response()->json(['success' => true, 'data' => $categories]);
    }

    public function trackView(Request $request, int $id): JsonResponse
    {
        $job = Job::findOrFail($id);

        JobView::create([
            'job_id' => $job->id,
            'user_id' => $request->user()?->id,
            'ip_address' => $request->ip(),
            'user_agent' => $request->userAgent(),
            'referer' => $request->header('referer'),
        ]);

        $job->incrementViews();

        return response()->json(['success' => true]);
    }

    public function trackClick(Request $request, int $id): JsonResponse
    {
        $job = Job::findOrFail($id);

        JobClick::create([
            'job_id' => $job->id,
            'user_id' => $request->user()?->id,
            'click_type' => $request->input('type', 'apply'),
            'ip_address' => $request->ip(),
        ]);

        $job->incrementClicks();

        return response()->json(['success' => true]);
    }
}
