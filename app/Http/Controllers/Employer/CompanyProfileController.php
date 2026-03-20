<?php

namespace App\Http\Controllers\Employer;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CompanyProfileController extends Controller
{
    public function show(Request $request): JsonResponse
    {
        $user = $request->user();
        $company = $user->ownedCompany ?? $user->company;

        return response()->json([
            'success' => true,
            'data' => [
                'user' => $user->only(['id', 'name', 'email', 'phone', 'avatar', 'role', 'created_at']),
                'company' => $company,
            ],
        ]);
    }

    public function update(Request $request): JsonResponse
    {
        $user = $request->user();

        $request->validate([
            'company_name' => 'sometimes|string|max:255',
            'description' => 'sometimes|string|max:3000',
            'website' => 'sometimes|string|max:255',
            'location' => 'sometimes|string|max:255',
            'size' => 'sometimes|string|max:50',
            'founded_year' => 'sometimes|integer|min:1900|max:2030',
            'telegram_channel' => 'sometimes|string|max:255',
            'communication_language_priority' => 'sometimes|string|max:10',
            'communication_languages_acceptable' => 'sometimes|array',
            'communication_languages_acceptable.*' => 'string|max:10',
            'main_office_countries' => 'sometimes|array',
            'main_office_countries.*' => 'string|max:100',
            'blocked_candidate_citizenships' => 'sometimes|array',
            'blocked_candidate_citizenships.*' => 'string|max:100',
            'candidate_location_pref' => 'sometimes|string|in:outside,all',
        ]);

        // Update user name/phone if provided
        $user->update($request->only(['name', 'phone']));

        $company = $user->ownedCompany;
        if (!$company) {
            $company = \App\Models\Company::create([
                'user_id' => $user->id,
                'name' => $request->input('company_name', $user->name . "'s Company"),
                'slug' => \Illuminate\Support\Str::slug($user->name . '-' . $user->id),
                'plan' => 'free',
            ]);
        }

        $companyData = $request->only([
            'description', 'website', 'location', 'size', 'founded_year',
            'telegram_channel',
            'communication_language_priority', 'communication_languages_acceptable',
            'main_office_countries', 'blocked_candidate_citizenships', 'candidate_location_pref',
        ]);

        if ($request->has('company_name')) {
            $companyData['name'] = $request->input('company_name');
        }

        $company->update($companyData);

        return response()->json([
            'success' => true,
            'data' => $user->fresh()->load('ownedCompany'),
        ]);
    }
}
