<?php

namespace App\Http\Controllers\Employer;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ApplicationsController extends Controller
{
    public function index(Request $request, int $id): JsonResponse
    {
        return response()->json(['success' => true, 'data' => []]);
    }

    public function update(Request $request, int $jobId, int $appId): JsonResponse
    {
        return response()->json(['success' => true, 'message' => 'Application updated.']);
    }
}
