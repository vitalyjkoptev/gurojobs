<?php

namespace App\Enums;

enum JobType: string
{
    case FullTime = 'full-time';
    case PartTime = 'part-time';
    case Contract = 'contract';
    case Freelance = 'freelance';

    public function label(): string
    {
        return match ($this) {
            self::FullTime => 'Full-Time',
            self::PartTime => 'Part-Time',
            self::Contract => 'Contract',
            self::Freelance => 'Freelance',
        };
    }
}
