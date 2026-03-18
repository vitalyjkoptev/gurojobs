<?php

namespace App\Http\Controllers\Payment;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class StripeController extends Controller
{
    public function checkout(Request $request): JsonResponse
    {
        return response()->json(['success' => true, 'message' => 'Stripe checkout session created.']);
    }

    public function webhook(Request $request): JsonResponse
    {
        return response()->json(['received' => true]);
    }
}
