<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->isAdmin()) {
            return redirect()->route('admin.dashboard');
        }

        if ($user->isEmployer()) {
            $user->load('ownedCompany');
            $company = $user->ownedCompany;
            $activeJobs = $company ? $company->activeJobs()->count() : 0;
            $totalApplications = $company
                ? \App\Models\JobApplication::whereIn('job_id', $company->jobs()->pluck('id'))->count()
                : 0;

            return view('employer.dashboard', compact('user', 'company', 'activeJobs', 'totalApplications'));
        }

        // Candidate
        $user->load('candidateProfile', 'applications');
        $profile = $user->candidateProfile;
        $applications = $user->applications()->with('job.company')->latest()->take(5)->get();
        $applicationsCount = $user->applications()->count();

        return view('candidate.dashboard', compact('user', 'profile', 'applications', 'applicationsCount'));
    }
}
