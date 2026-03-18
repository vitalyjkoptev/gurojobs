<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Job;
use App\Models\Company;
use App\Models\User;
use Illuminate\Http\JsonResponse;

class DashboardController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => [
                'total_jobs' => Job::count(),
                'active_jobs' => Job::where('status', 'active')->count(),
                'total_companies' => Company::count(),
                'total_users' => User::count(),
            ],
        ]);
    }
}
