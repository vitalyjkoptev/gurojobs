<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class TrackLastSeen
{
    /**
     * Обновляем last_seen_at не чаще 1 раза в 5 минут (снижаем нагрузку на БД).
     */
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if ($user && (!$user->last_seen_at || $user->last_seen_at->diffInMinutes(now()) >= 5)) {
            $user->timestamps = false; // не менять updated_at
            $user->update(['last_seen_at' => now()]);
            $user->timestamps = true;
        }

        return $next($request);
    }
}
