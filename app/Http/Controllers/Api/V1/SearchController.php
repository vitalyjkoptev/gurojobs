<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\CandidateProfile;
use App\Models\Job;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SearchController extends Controller
{
    /**
     * Full keyword search — user types "CMO", "slot developer", etc.
     * Highlights matching terms in results.
     */
    public function search(Request $request): JsonResponse
    {
        $request->validate(['q' => 'required|string|min:2|max:200']);

        $q = $request->input('q');

        $query = Job::active()
            ->with(['company:id,name,slug,logo,verified', 'category:id,name,slug'])
            ->search($q);

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
            $query->whereHas('category', fn($qb) => $qb->where('slug', $category));
        }

        $jobs = $query->latest()->paginate($request->input('per_page', 20));

        // Add highlight info
        $jobs->getCollection()->transform(function ($job) use ($q) {
            $job->highlight = [
                'title' => $this->highlight($job->title, $q),
                'description' => $this->highlight(
                    \Illuminate\Support\Str::limit(strip_tags($job->description), 300),
                    $q
                ),
            ];
            return $job;
        });

        return response()->json($jobs);
    }

    /**
     * Autocomplete suggestions — returns position titles matching query.
     */
    public function suggest(Request $request): JsonResponse
    {
        $q = $request->input('q', '');
        if (strlen($q) < 2) {
            return response()->json(['data' => []]);
        }

        $positions = DB::table('igaming_positions')
            ->where('title', 'like', "%{$q}%")
            ->orWhere('aliases', 'like', "%{$q}%")
            ->limit(10)
            ->get(['title', 'category_slug', 'experience_level', 'aliases']);

        // Also suggest from job titles
        $jobTitles = Job::active()
            ->where('title', 'like', "%{$q}%")
            ->limit(5)
            ->pluck('title')
            ->unique();

        return response()->json([
            'data' => [
                'positions' => $positions,
                'job_titles' => $jobTitles,
            ],
        ]);
    }

    /**
     * List all iGaming positions (for autocomplete dropdown).
     */
    public function positions(Request $request): JsonResponse
    {
        $level = $request->input('level');

        $query = DB::table('igaming_positions');

        if ($level) {
            $query->where('experience_level', $level);
        }

        $positions = $query->orderBy('title')->get(['title', 'category_slug', 'experience_level']);

        return response()->json(['success' => true, 'data' => $positions]);
    }

    /**
     * Search candidates — employer filters (blocked citizenships, location pref).
     * GET /api/v1/search/candidates
     */
    public function candidates(Request $request): JsonResponse
    {
        $user = $request->user();
        $company = $user->ownedCompany ?? $user->company;

        $query = CandidateProfile::with('user:id,name,avatar,last_seen_at,created_at')
            ->whereHas('user', fn($q) => $q->where('status', 'active'));

        // Keyword search (skills, headline, bio)
        if ($q = $request->input('q')) {
            $query->where(function ($sub) use ($q) {
                $sub->where('headline', 'like', "%{$q}%")
                    ->orWhere('bio', 'like', "%{$q}%")
                    ->orWhereRaw("JSON_SEARCH(skills, 'one', ?) IS NOT NULL", ["%{$q}%"]);
            });
        }

        // Experience level filter
        if ($level = $request->input('experience_level')) {
            $query->where('experience_level', $level);
        }

        // Availability filter
        if ($avail = $request->input('availability')) {
            $query->where('availability', $avail);
        }

        // Location filter
        if ($loc = $request->input('location')) {
            $query->where('location', 'like', "%{$loc}%");
        }

        // Employer: blocked candidate citizenships
        if ($company && !empty($company->blocked_candidate_citizenships)) {
            $blocked = $company->blocked_candidate_citizenships;
            $query->where(function ($sub) use ($blocked) {
                $sub->whereNull('citizenship_country')
                    ->orWhereNotIn('citizenship_country', $blocked);
            });
        }

        // Employer: show only candidates outside their citizenship country
        if ($company && $company->candidate_location_pref === 'outside') {
            $query->where(function ($sub) {
                $sub->where('in_citizenship_country', false)
                    ->orWhereNull('in_citizenship_country');
            });
        }

        $candidates = $query->latest()->paginate($request->input('per_page', 20));

        return response()->json($candidates);
    }

    /**
     * Wrap matching terms in <mark> tags for frontend highlighting.
     */
    protected function highlight(string $text, string $query): string
    {
        $words = preg_split('/\s+/', $query);
        foreach ($words as $word) {
            if (strlen($word) >= 2) {
                $escaped = preg_quote($word, '/');
                $text = preg_replace("/({$escaped})/iu", '<mark>$1</mark>', $text);
            }
        }
        return $text;
    }
}
