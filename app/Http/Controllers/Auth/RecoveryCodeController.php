<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Services\Auth\RecoveryCodeService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class RecoveryCodeController extends Controller
{
    public function __construct(protected RecoveryCodeService $recoveryService)
    {
    }

    /**
     * Generate new recovery codes for the authenticated user.
     * Returns plain-text codes — user must save them. Shown only ONCE.
     */
    public function generate(Request $request): JsonResponse
    {
        $request->validate([
            'password' => 'required|current_password',
        ]);

        $codes = $this->recoveryService->generate($request->user());

        return response()->json([
            'success' => true,
            'message' => 'Recovery codes generated. Save them in a safe place. They will not be shown again.',
            'codes' => $codes,
            'count' => count($codes),
        ]);
    }

    /**
     * Regenerate recovery codes (invalidates old ones).
     */
    public function regenerate(Request $request): JsonResponse
    {
        $request->validate([
            'password' => 'required|current_password',
        ]);

        $codes = $this->recoveryService->regenerate($request->user());

        return response()->json([
            'success' => true,
            'message' => 'New recovery codes generated. All previous codes are now invalid.',
            'codes' => $codes,
            'count' => count($codes),
        ]);
    }

    /**
     * Login with a recovery code (when passkey/password unavailable).
     */
    public function loginWithCode(Request $request): JsonResponse
    {
        $request->validate([
            'email' => 'required|email',
            'recovery_code' => 'required|string',
        ]);

        $user = \App\Models\User::where('email', $request->email)->first();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid credentials.',
            ], 401);
        }

        if (!$this->recoveryService->verify($user, $request->recovery_code)) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid or already used recovery code.',
            ], 401);
        }

        $token = $user->createToken('recovery-login')->plainTextToken;
        $remaining = $this->recoveryService->remaining($user);

        return response()->json([
            'success' => true,
            'message' => "Logged in with recovery code. You have {$remaining} codes remaining.",
            'token' => $token,
            'user' => $user,
            'remaining_codes' => $remaining,
        ]);
    }

    /**
     * Check how many recovery codes are remaining.
     */
    public function status(Request $request): JsonResponse
    {
        $user = $request->user();

        return response()->json([
            'has_codes' => $this->recoveryService->hasRecoveryCodes($user),
            'remaining' => $this->recoveryService->remaining($user),
            'generated_at' => $user->recovery_codes_generated_at,
        ]);
    }
}
