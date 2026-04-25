<?php

namespace App\Http\Controllers\Auth;

use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class OnboardingController extends Controller
{
    public function show(Request $request): View|RedirectResponse
    {
        $user = $request->user();

        if (!$user->needsOnboarding()) {
            return redirect()->intended(config('gurojobs.telegram.auth_redirect', '/dashboard'));
        }

        return view('auth.onboarding', ['user' => $user]);
    }

    public function store(Request $request): RedirectResponse
    {
        $user = $request->user();

        $data = $request->validate([
            'role' => ['required', Rule::in(['employer', 'candidate'])],
            'email' => ['required', 'email', Rule::unique('users', 'email')->ignore($user->id)],
            'password' => ['nullable', 'string', 'min:8', 'confirmed'],
        ]);

        $user->forceFill([
            'role' => $data['role'] === 'employer' ? UserRole::Employer : UserRole::Candidate,
            'email' => $data['email'],
            'password' => !empty($data['password']) ? Hash::make($data['password']) : $user->password,
            'status' => 'active',
            'onboarded_at' => now(),
        ])->save();

        return redirect()->intended(config('gurojobs.telegram.auth_redirect', '/dashboard'))
            ->with('success', 'Welcome aboard!');
    }
}
