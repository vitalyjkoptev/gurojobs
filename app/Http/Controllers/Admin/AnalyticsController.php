<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;

class AnalyticsController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(['success' => true, 'data' => []]);
    }
}
