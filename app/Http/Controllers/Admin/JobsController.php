<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Job;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class JobsController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(Job::with('company')->latest()->paginate(20));
    }

    public function store(Request $request): JsonResponse
    {
        return response()->json(['success' => true], 201);
    }

    public function show(int $id): JsonResponse
    {
        return response()->json(['success' => true, 'data' => Job::with('company')->findOrFail($id)]);
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
