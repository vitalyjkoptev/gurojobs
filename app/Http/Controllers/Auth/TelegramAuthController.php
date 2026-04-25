<?php

namespace App\Http\Controllers\Auth;

use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use Illuminate\View\View;

class TelegramAuthController extends Controller
{
    /**
     * Страница с виджетом Telegram Login.
     * Отображается во всплывающем окне (popup), открытом со страницы /login.
     */
    public function redirect(): View
    {
        return view('auth.telegram-redirect', [
            'botUsername' => config('gurojobs.telegram.bot_username'),
            'authUrl' => url('/auth/telegram/callback'),
        ]);
    }

    /**
     * Колбэк от Telegram Login Widget.
     * Telegram кладёт параметры в query: id, first_name, last_name?, username?, photo_url?, auth_date, hash.
     */
    public function callback(Request $request)
    {
        $payload = $this->extractPayload($request);

        if (!$this->verifySignature($payload)) {
            Log::warning('Telegram auth: bad signature', ['payload' => $payload]);
            abort(403, 'Invalid Telegram signature');
        }

        if ($this->isExpired($payload)) {
            Log::warning('Telegram auth: expired', ['auth_date' => $payload['auth_date'] ?? null]);
            abort(403, 'Telegram auth payload expired');
        }

        $telegramId = (string) $payload['id'];
        $user = User::where('telegram_id', $telegramId)->first();

        if (!$user) {
            $user = User::create([
                'name' => $this->buildName($payload),
                'email' => null,
                'password' => Hash::make(Str::random(40)),
                'telegram_id' => $telegramId,
                'telegram_username' => isset($payload['username']) ? '@' . ltrim($payload['username'], '@') : null,
                'avatar' => $payload['photo_url'] ?? null,
                'role' => UserRole::Candidate,
                'status' => 'pending',
            ]);
        } else {
            $user->forceFill([
                'telegram_username' => isset($payload['username']) ? '@' . ltrim($payload['username'], '@') : $user->telegram_username,
                'avatar' => $user->avatar ?: ($payload['photo_url'] ?? null),
                'last_seen_at' => now(),
            ])->save();
        }

        Auth::login($user, true);

        $token = $user->createToken('telegram-auth')->plainTextToken;
        $redirect = $user->needsOnboarding()
            ? url('/onboarding')
            : url(config('gurojobs.telegram.auth_redirect', '/dashboard'));

        if ($request->expectsJson() || $request->is('api/*')) {
            return response()->json([
                'success' => true,
                'token' => $token,
                'user' => $user,
                'needs_onboarding' => $user->needsOnboarding(),
                'redirect' => $redirect,
            ]);
        }

        return response()->view('auth.telegram-callback', [
            'token' => $token,
            'redirect' => $redirect,
        ]);
    }

    /**
     * Связать Telegram-аккаунт с уже залогиненным пользователем.
     * Принимает тот же payload, что и /callback, но не создаёт нового пользователя.
     */
    public function link(Request $request): JsonResponse
    {
        $payload = $this->extractPayload($request);

        if (!$this->verifySignature($payload) || $this->isExpired($payload)) {
            return response()->json(['success' => false, 'message' => 'Invalid Telegram payload'], 403);
        }

        $telegramId = (string) $payload['id'];

        $existing = User::where('telegram_id', $telegramId)->first();
        if ($existing && $existing->id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'This Telegram account is already linked to another user.',
            ], 409);
        }

        $request->user()->forceFill([
            'telegram_id' => $telegramId,
            'telegram_username' => isset($payload['username']) ? '@' . ltrim($payload['username'], '@') : null,
        ])->save();

        return response()->json(['success' => true]);
    }

    public function unlink(Request $request): JsonResponse
    {
        $request->user()->forceFill([
            'telegram_id' => null,
        ])->save();

        return response()->json(['success' => true]);
    }

    // ── Internals ────────────────────────────────────────────────

    private function extractPayload(Request $request): array
    {
        $allowed = ['id', 'first_name', 'last_name', 'username', 'photo_url', 'auth_date', 'hash'];
        return array_filter(
            $request->only($allowed),
            fn($v) => $v !== null && $v !== ''
        );
    }

    private function verifySignature(array $payload): bool
    {
        $token = config('gurojobs.telegram.bot_token');
        if (empty($token) || empty($payload['hash'])) {
            return false;
        }

        $check = collect($payload)
            ->except('hash')
            ->map(fn($v, $k) => "$k=$v")
            ->sort()
            ->values()
            ->implode("\n");

        $secret = hash('sha256', $token, true);
        $hmac = hash_hmac('sha256', $check, $secret);

        return hash_equals($hmac, (string) $payload['hash']);
    }

    private function isExpired(array $payload): bool
    {
        $authDate = (int) ($payload['auth_date'] ?? 0);
        $ttl = (int) config('gurojobs.telegram.auth_ttl', 86400);
        return $authDate <= 0 || (time() - $authDate) > $ttl;
    }

    private function buildName(array $payload): string
    {
        $name = trim(($payload['first_name'] ?? '') . ' ' . ($payload['last_name'] ?? ''));
        if ($name === '' && !empty($payload['username'])) {
            $name = '@' . ltrim($payload['username'], '@');
        }
        return $name !== '' ? $name : 'Telegram user';
    }
}
