<?php

namespace App\Enums;

enum WorkMode: string
{
    case Remote = 'remote';
    case OnSite = 'on-site';
    case Hybrid = 'hybrid';

    public function label(): string
    {
        return match ($this) {
            self::Remote => 'Remote',
            self::OnSite => 'On-Site',
            self::Hybrid => 'Hybrid',
        };
    }
}
