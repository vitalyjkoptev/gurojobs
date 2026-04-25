<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureOnboarded
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if ($user && $user->needsOnboarding() && !$request->routeIs('onboarding', 'onboarding.store', 'logout')) {
            if ($request->expectsJson()) {
                return response()->json([
                    'success' => false,
                    'code' => 'onboarding_required',
                    'message' => 'Complete your profile to continue.',
                ], 409);
            }

            return redirect()->route('onboarding');
        }

        return $next($request);
    }
}
