<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class RoleMiddleware
{
    public function handle(Request $request, Closure $next, string ...$roles): Response
    {
        $user = $request->user();

        if (!$user) {
            return $request->expectsJson()
                ? response()->json(['message' => 'Unauthenticated.'], 401)
                : redirect()->route('login');
        }

        $userRole = $user->role instanceof \App\Enums\UserRole
            ? $user->role->value
            : $user->role;

        if (!in_array($userRole, $roles)) {
            return $request->expectsJson()
                ? response()->json(['message' => 'Forbidden.'], 403)
                : abort(403, 'Access denied.');
        }

        return $next($request);
    }
}
