<?php

namespace App\Http\Controllers\Employer;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CompanyProfileController extends Controller
{
    public function show(Request $request): JsonResponse
    {
        return response()->json(['success' => true, 'data' => null]);
    }

    public function update(Request $request): JsonResponse
    {
        return response()->json(['success' => true, 'message' => 'Company updated.']);
    }
}
