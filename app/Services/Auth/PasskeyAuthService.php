<?php

namespace App\Services\Auth;

use App\Models\User;

/**
 * Passkey (WebAuthn) Authentication Service
 *
 * Uses laragear/webauthn package for Laravel 12.
 * Supports: FaceID, TouchID, Windows Hello, YubiKey.
 *
 * Auth Flow:
 * 1. User enters email
 * 2. System checks if user has passkey registered
 * 3a. If yes → WebAuthn challenge → FaceID/TouchID → Login
 * 3b. If no → Offer to create passkey, fallback to password
 * 4. On first login → auto-offer passkey registration
 * 5. Recovery codes as ultimate fallback
 *
 * composer require laragear/webauthn
 */
class PasskeyAuthService
{
    /**
     * Check if user has passkeys registered.
     */
    public function hasPasskeys(User $user): bool
    {
        return $user->webAuthnCredentials()->exists();
    }

    /**
     * Get auth methods available for a user.
     */
    public function availableMethods(User $user): array
    {
        $methods = [];

        if ($this->hasPasskeys($user)) {
            $methods[] = [
                'type' => 'passkey',
                'label' => 'Passkey (FaceID / TouchID)',
                'primary' => true,
            ];
        }

        // Hardware key (also WebAuthn but cross-platform)
        if ($user->webAuthnCredentials()->where('is_cross_platform', true)->exists()) {
            $methods[] = [
                'type' => 'hardware_key',
                'label' => 'Hardware Key (YubiKey)',
                'primary' => false,
            ];
        }

        // Password always available
        if ($user->password) {
            $methods[] = [
                'type' => 'password',
                'label' => 'Password',
                'primary' => empty($methods),
            ];
        }

        // Recovery codes
        if (!empty($user->recovery_codes)) {
            $methods[] = [
                'type' => 'recovery_code',
                'label' => 'Recovery Code',
                'primary' => false,
            ];
        }

        return $methods;
    }

    /**
     * Determine best auth method for login flow.
     */
    public function recommendedMethod(User $user): string
    {
        if ($this->hasPasskeys($user)) {
            return 'passkey';
        }

        if ($user->password) {
            return 'password';
        }

        return 'recovery_code';
    }

    /**
     * Should we prompt user to set up passkey?
     */
    public function shouldOfferPasskeySetup(User $user): bool
    {
        return !$this->hasPasskeys($user) && $user->email_verified_at !== null;
    }
}
