<?php

namespace App\Http\Controllers\Candidate;

use App\Http\Controllers\Controller;
use App\Models\CandidateProfile;
use App\Models\User;
use App\Services\Paywall\PaywallService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    public function __construct(
        private PaywallService $paywall
    ) {}

    /**
     * GET /api/v1/candidate/profile
     * Свой профиль кандидата (полный, без пейволла).
     */
    public function show(Request $request): JsonResponse
    {
        $user = $request->user();
        $profile = $user->candidateProfile;

        return response()->json([
            'success' => true,
            'data' => [
                'user' => $user->only(['id', 'name', 'email', 'phone', 'avatar', 'role', 'created_at', 'last_seen_at']),
                'profile' => $profile,
                'resume_updated_at' => $profile?->resume_updated_at?->toISOString(),
            ],
        ]);
    }

    /**
     * PUT /api/v1/candidate/profile
     * Обновить профиль.
     */
    public function update(Request $request): JsonResponse
    {
        $user = $request->user();

        $request->validate([
            'name' => 'sometimes|string|max:255',
            'phone' => 'sometimes|string|max:50',
            'headline' => 'sometimes|string|max:255',
            'bio' => 'sometimes|string|max:3000',
            'experience_level' => 'sometimes|string',
            'skills' => 'sometimes|array',
            'languages' => 'sometimes|array',
            'communication_language_priority' => 'sometimes|string|max:10',
            'communication_languages_acceptable' => 'sometimes|array',
            'communication_languages_acceptable.*' => 'string|max:10',
            'salary_min' => 'sometimes|numeric|min:0',
            'salary_max' => 'sometimes|numeric|min:0',
            'salary_currency' => 'sometimes|string|max:3',
            'availability' => 'sometimes|string|in:actively_looking,open,not_looking',
            'location' => 'sometimes|string|max:255',
            'remote_ok' => 'sometimes|boolean',
            'citizenship_country' => 'sometimes|string|max:100',
            'in_citizenship_country' => 'sometimes|boolean',
            'blocked_company_countries' => 'sometimes|array',
            'blocked_company_countries.*' => 'string|max:100',
            'linkedin' => 'sometimes|string|max:255',
            'github' => 'sometimes|string|max:255',
            'portfolio' => 'sometimes|string|max:255',
            'telegram' => 'sometimes|string|max:255',
        ]);

        $user->update($request->only(['name', 'phone']));

        $profileData = $request->only([
            'headline', 'bio', 'experience_level', 'skills', 'languages',
            'communication_language_priority', 'communication_languages_acceptable',
            'salary_min', 'salary_max', 'salary_currency',
            'availability', 'location', 'remote_ok',
            'citizenship_country', 'in_citizenship_country', 'blocked_company_countries',
            'linkedin', 'github', 'portfolio', 'telegram',
        ]);

        $profile = $user->candidateProfile;
        if ($profile) {
            $profile->update($profileData);
        } else {
            $profileData['user_id'] = $user->id;
            $profile = CandidateProfile::create($profileData);
        }

        return response()->json([
            'success' => true,
            'data' => $user->fresh()->load('candidateProfile'),
        ]);
    }

    /**
     * GET /api/v1/candidates/{id}
     * Публичный профиль кандидата (для рекрутеров, с пейволлом).
     * Показывает: имя, X лет на платформе, был в сети DD.MM, дата обновления резюме.
     */
    public function publicProfile(Request $request, int $id): JsonResponse
    {
        $viewer = $request->user();
        $candidate = User::with('candidateProfile')->findOrFail($id);

        if (!$candidate->isCandidate()) {
            return response()->json([
                'success' => false,
                'message' => 'User is not a candidate.',
            ], 404);
        }

        $profile = $candidate->candidateProfile;
        $profileData = $profile ? $profile->toArray() : [];

        $profileData['name'] = $candidate->name;
        $profileData['email'] = $candidate->email;
        $profileData['phone'] = $candidate->phone;
        $profileData['avatar'] = $candidate->avatar;
        $profileData['member_since'] = $candidate->created_at->toISOString();
        $profileData['years_on_platform'] = $candidate->created_at->diffInYears(now());
        $profileData['last_seen_at'] = $candidate->last_seen_at?->toISOString();
        $profileData['resume_updated_at'] = $profile?->resume_updated_at?->toISOString();

        // Пейволл
        $profileData = $this->paywall->filterProfileData($profileData, $viewer);

        return response()->json([
            'success' => true,
            'data' => $profileData,
            'paywall' => $this->paywall->getPaywallStatus($viewer),
        ]);
    }

    /**
     * GET /api/v1/employers/{id}
     * Публичный профиль рекрутера/компании (для кандидатов).
     * Показывает: компания, X лет на платформе, был в сети DD.MM, рейтинг.
     */
    public function recruiterProfile(Request $request, int $id): JsonResponse
    {
        $viewer = $request->user();
        $employer = User::with('company')->findOrFail($id);

        if (!$employer->isEmployer()) {
            return response()->json([
                'success' => false,
                'message' => 'User is not an employer.',
            ], 404);
        }

        $company = $employer->company ?? $employer->ownedCompany;

        $data = [
            'id' => $employer->id,
            'name' => $employer->name,
            'avatar' => $employer->avatar,
            'member_since' => $employer->created_at->toISOString(),
            'years_on_platform' => $employer->created_at->diffInYears(now()),
            'last_seen_at' => $employer->last_seen_at?->toISOString(),
            'company' => $company ? [
                'id' => $company->id,
                'name' => $company->name,
                'logo' => $company->logo,
                'location' => $company->location,
                'size' => $company->size,
                'rating_avg' => $company->rating_avg,
                'rating_count' => $company->rating_count,
                'verified' => $company->verified,
                'active_jobs_count' => $company->activeJobs()->count(),
            ] : null,
        ];

        // Пейволл: скрываем website/telegram компании для free
        if ($company && !$this->paywall->canViewFullProfile($viewer)) {
            $data['company']['website'] = '*** Upgrade to view ***';
            $data['company']['telegram_channel'] = '*** Upgrade to view ***';
            $data['_paywall'] = true;
            $data['_paywall_message'] = 'Upgrade to see full company info.';
        } elseif ($company) {
            $data['company']['website'] = $company->website;
            $data['company']['telegram_channel'] = $company->telegram_channel;
        }

        return response()->json([
            'success' => true,
            'data' => $data,
            'paywall' => $this->paywall->getPaywallStatus($viewer),
        ]);
    }
}
