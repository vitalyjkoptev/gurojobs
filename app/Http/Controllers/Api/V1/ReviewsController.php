<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ReviewsController extends Controller
{
    public function reviewEmployer(Request $request, int $companyId): JsonResponse
    {
        return response()->json(['success' => true, 'message' => 'Review submitted.']);
    }

    public function reviewCandidate(Request $request, int $profileId): JsonResponse
    {
        return response()->json(['success' => true, 'message' => 'Review submitted.']);
    }

    public function employerReviews(int $companyId): JsonResponse
    {
        return response()->json(['success' => true, 'data' => []]);
    }

    public function candidateReviews(int $profileId): JsonResponse
    {
        return response()->json(['success' => true, 'data' => []]);
    }
}
