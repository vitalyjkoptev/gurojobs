<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request): JsonResponse
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        $credentials = [
            'email' => $request->input('email'),
            'password' => $request->input('password'),
        ];

        if (!Auth::attempt($credentials)) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid credentials.',
            ], 401);
        }

        $user = Auth::user();

        if ($user->status === 'banned') {
            Auth::logout();
            return response()->json([
                'success' => false,
                'message' => 'Account suspended.',
            ], 403);
        }

        $token = $user->createToken('auth')->plainTextToken;

        return response()->json([
            'success' => true,
            'token' => $token,
            'user' => $user,
        ]);
    }

    public function register(Request $request): JsonResponse
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|confirmed|min:8',
            'role' => 'required|in:employer,candidate',
            'phone' => 'nullable|string|max:20',
            'telegram_username' => 'nullable|string|max:100',
            // Language & country filters
            'communication_language_priority' => 'nullable|string|max:10',
            'communication_languages_acceptable' => 'nullable|array',
            'communication_languages_acceptable.*' => 'string|max:10',
            // Candidate-specific
            'citizenship_country' => 'nullable|string|max:100',
            'in_citizenship_country' => 'nullable|boolean',
            'blocked_company_countries' => 'nullable|array',
            'blocked_company_countries.*' => 'string|max:100',
            // Employer-specific
            'main_office_countries' => 'nullable|array',
            'main_office_countries.*' => 'string|max:100',
            'blocked_candidate_citizenships' => 'nullable|array',
            'blocked_candidate_citizenships.*' => 'string|max:100',
            'candidate_location_pref' => 'nullable|string|in:outside,all',
        ]);

        $user = User::create([
            'name' => $request->input('name'),
            'email' => $request->input('email'),
            'password' => Hash::make($request->input('password')),
            'role' => $request->input('role'),
            'phone' => $request->input('phone'),
            'telegram_username' => $request->input('telegram_username'),
            'status' => 'active',
        ]);

        $role = $request->input('role');

        // Create profile with filter preferences
        if ($role === 'candidate') {
            \App\Models\CandidateProfile::create([
                'user_id' => $user->id,
                'communication_language_priority' => $request->input('communication_language_priority'),
                'communication_languages_acceptable' => $request->input('communication_languages_acceptable'),
                'citizenship_country' => $request->input('citizenship_country'),
                'in_citizenship_country' => $request->input('in_citizenship_country'),
                'blocked_company_countries' => $request->input('blocked_company_countries'),
            ]);
        } elseif ($role === 'employer') {
            \App\Models\Company::create([
                'user_id' => $user->id,
                'name' => $request->input('name') . "'s Company",
                'slug' => \Illuminate\Support\Str::slug($request->input('name') . '-' . $user->id),
                'plan' => 'free',
                'communication_language_priority' => $request->input('communication_language_priority'),
                'communication_languages_acceptable' => $request->input('communication_languages_acceptable'),
                'main_office_countries' => $request->input('main_office_countries'),
                'blocked_candidate_citizenships' => $request->input('blocked_candidate_citizenships'),
                'candidate_location_pref' => $request->input('candidate_location_pref', 'all'),
            ]);
        }

        $token = $user->createToken('auth')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Registration successful.',
            'token' => $token,
            'user' => $user->load($role === 'candidate' ? 'candidateProfile' : 'ownedCompany'),
        ], 201);
    }

    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json(['success' => true, 'message' => 'Logged out.']);
    }

    public function me(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'user' => $request->user(),
        ]);
    }
}
