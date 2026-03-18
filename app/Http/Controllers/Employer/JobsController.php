<?php

namespace App\Http\Controllers\Employer;

use App\Http\Controllers\Controller;
use App\Models\Job;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class JobsController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $jobs = Job::where('company_id', $request->user()->company_id)
            ->latest()
            ->paginate(20);
        return response()->json($jobs);
    }

    public function store(Request $request): JsonResponse
    {
        return response()->json(['success' => true, 'message' => 'Job created.'], 201);
    }

    public function show(int $id): JsonResponse
    {
        $job = Job::findOrFail($id);
        return response()->json(['success' => true, 'data' => $job]);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        return response()->json(['success' => true, 'message' => 'Job updated.']);
    }

    public function destroy(int $id): JsonResponse
    {
        return response()->json(['success' => true, 'message' => 'Job deleted.']);
    }
}
