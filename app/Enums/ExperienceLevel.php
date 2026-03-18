<?php

namespace App\Enums;

enum ExperienceLevel: string
{
    case CLevel = 'c-level';
    case Head = 'head';
    case Senior = 'senior';
    case Middle = 'middle';
    case Junior = 'junior';

    public function label(): string
    {
        return match ($this) {
            self::CLevel => 'C-Level',
            self::Head => 'Head',
            self::Senior => 'Senior',
            self::Middle => 'Middle',
            self::Junior => 'Junior',
        };
    }

    public function order(): int
    {
        return match ($this) {
            self::CLevel => 1,
            self::Head => 2,
            self::Senior => 3,
            self::Middle => 4,
            self::Junior => 5,
        };
    }
}
