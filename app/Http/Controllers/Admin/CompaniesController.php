<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Company;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CompaniesController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(Company::latest()->paginate(20));
    }

    public function store(Request $request): JsonResponse
    {
        return response()->json(['success' => true], 201);
    }

    public function show(int $id): JsonResponse
    {
        return response()->json(['success' => true, 'data' => Company::findOrFail($id)]);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        return response()->json(['success' => true, 'message' => 'Company updated.']);
    }

    public function destroy(int $id): JsonResponse
    {
        return response()->json(['success' => true, 'message' => 'Company deleted.']);
    }
}
