<?php

namespace App\Http\Controllers\Auth;

use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\CandidateProfile;
use App\Models\Company;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;

class WebAuthController extends Controller
{
    public function showRegister()
    {
        return view('auth.register');
    }

    public function register(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => ['required', 'confirmed', Password::min(8)],
            'role' => 'required|in:employer,candidate',
            'terms' => 'accepted',
        ]);

        $user = User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => stripslashes($data['password']),
            'role' => $data['role'],
            'status' => 'active',
        ]);

        // Create empty profile based on role
        if ($data['role'] === 'candidate') {
            CandidateProfile::create(['user_id' => $user->id]);
        } elseif ($data['role'] === 'employer') {
            Company::create([
                'user_id' => $user->id,
                'name' => $data['name'] . "'s Company",
                'slug' => \Str::slug($data['name'] . '-' . $user->id),
                'plan' => 'free',
            ]);
        }

        Auth::login($user);

        return redirect()->route('dashboard');
    }

    public function showLogin()
    {
        return view('auth.login');
    }

    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        // Strip backslash-escaping that cPanel/mod_security adds to special chars
        $credentials['password'] = stripslashes($credentials['password']);

        if (Auth::attempt($credentials, $request->boolean('remember'))) {
            $request->session()->regenerate();

            $user = Auth::user();

            if ($user->status === 'banned') {
                Auth::logout();
                return back()->withErrors(['email' => 'Account suspended.']);
            }

            // Role-based redirect
            $loginRole = $request->input('login_role');

            if ($user->role === UserRole::Admin) {
                return redirect()->intended(route('admin.dashboard'));
            }

            if ($loginRole && $user->role->value !== $loginRole && $user->role !== UserRole::Admin) {
                Auth::logout();
                return back()->withErrors(['email' => 'This account is not registered as ' . $loginRole . '.'])->onlyInput('email');
            }

            return redirect()->intended(route('dashboard'));
        }

        return back()->withErrors(['email' => 'Invalid credentials.'])->onlyInput('email');
    }

    /**
     * Temporary demo skip login — creates/finds demo user and logs in instantly.
     * TODO: Remove before production launch.
     */
    public function demoLogin(Request $request)
    {
        $role = $request->query('role', 'candidate');

        if (!in_array($role, ['employer', 'candidate'])) {
            return redirect()->route('login');
        }

        $email = "demo-{$role}@gurojobs.com";

        $user = User::where('email', $email)->first();

        if (!$user) {
            $user = User::create([
                'name' => $role === 'employer' ? 'Demo Employer' : 'Demo Candidate',
                'email' => $email,
                'password' => env('DEMO_PASSWORD', 'DemoUser2026'),
                'role' => $role,
                'status' => 'active',
            ]);

            if ($role === 'candidate') {
                CandidateProfile::create([
                    'user_id' => $user->id,
                    'headline' => 'Senior iGaming Professional',
                    'bio' => 'Experienced professional with 5+ years in the iGaming industry. Skilled in operations management, player engagement, and regulatory compliance.',
                    'experience_level' => 'senior',
                    'skills' => json_encode(['iGaming', 'Operations', 'Compliance', 'Team Management', 'CRM']),
                    'languages' => json_encode(['English', 'German', 'Polish']),
                    'location' => 'Malta',
                    'remote_ok' => true,
                    'salary_min' => 60000,
                    'salary_max' => 90000,
                    'salary_currency' => 'EUR',
                    'availability' => 'immediately',
                ]);
            } elseif ($role === 'employer') {
                Company::create([
                    'user_id' => $user->id,
                    'name' => 'Demo Gaming Ltd',
                    'slug' => 'demo-gaming-ltd',
                    'description' => 'Leading iGaming operator with a global presence in sports betting and online casino entertainment.',
                    'website' => 'https://demo-gaming.com',
                    'location' => 'Malta',
                    'size' => '200-500',
                    'verified' => true,
                    'plan' => 'premium',
                    'rating_avg' => 4.6,
                ]);
            }
        }

        Auth::login($user);
        $request->session()->regenerate();

        return redirect()->route('dashboard');
    }

    public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect()->route('login');
    }
}
