<?php

namespace App\Services\Auth;

use App\Models\User;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Hash;

class RecoveryCodeService
{
    /**
     * Generate 8 recovery codes for a user.
     * Returns plain codes (show to user ONCE), stores hashed versions.
     */
    public function generate(User $user): array
    {
        $plainCodes = [];
        $hashedCodes = [];

        for ($i = 0; $i < 8; $i++) {
            $code = strtoupper(Str::random(4) . '-' . Str::random(4));
            $plainCodes[] = $code;
            $hashedCodes[] = [
                'hash' => Hash::make($code),
                'used_at' => null,
            ];
        }

        $user->update([
            'recovery_codes' => encrypt(json_encode($hashedCodes)),
            'recovery_codes_generated_at' => now(),
        ]);

        return $plainCodes;
    }

    /**
     * Verify a recovery code. If valid, marks it as used.
     */
    public function verify(User $user, string $code): bool
    {
        $codes = $this->getStoredCodes($user);
        if (!$codes) {
            return false;
        }

        $code = strtoupper(trim($code));

        foreach ($codes as $i => $stored) {
            if ($stored['used_at'] !== null) {
                continue; // Already used
            }

            if (Hash::check($code, $stored['hash'])) {
                $codes[$i]['used_at'] = now()->toIso8601String();
                $user->update([
                    'recovery_codes' => encrypt(json_encode($codes)),
                ]);
                return true;
            }
        }

        return false;
    }

    /**
     * Count remaining (unused) recovery codes.
     */
    public function remaining(User $user): int
    {
        $codes = $this->getStoredCodes($user);
        if (!$codes) {
            return 0;
        }

        return collect($codes)->whereNull('used_at')->count();
    }

    /**
     * Check if user has recovery codes set up.
     */
    public function hasRecoveryCodes(User $user): bool
    {
        return !empty($user->recovery_codes);
    }

    /**
     * Regenerate codes (invalidates all old codes).
     */
    public function regenerate(User $user): array
    {
        return $this->generate($user);
    }

    /**
     * Get stored codes (decrypted).
     */
    protected function getStoredCodes(User $user): ?array
    {
        if (empty($user->recovery_codes)) {
            return null;
        }

        try {
            return json_decode(decrypt($user->recovery_codes), true);
        } catch (\Exception $e) {
            return null;
        }
    }
}
