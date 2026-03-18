<?php

namespace App\Enums;

enum PaymentMethod: string
{
    case Stripe = 'stripe';
    case Crypto = 'crypto';
    case ApplePay = 'apple_pay';
    case GooglePay = 'google_pay';

    public function label(): string
    {
        return match ($this) {
            self::Stripe => 'Credit/Debit Card',
            self::Crypto => 'Cryptocurrency',
            self::ApplePay => 'Apple Pay',
            self::GooglePay => 'Google Pay',
        };
    }
}
