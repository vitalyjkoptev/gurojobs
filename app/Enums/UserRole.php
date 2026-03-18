<?php

namespace App\Enums;

enum UserRole: string
{
    case Admin = 'admin';
    case Employer = 'employer';
    case Candidate = 'candidate';

    public function label(): string
    {
        return match ($this) {
            self::Admin => 'Administrator',
            self::Employer => 'Employer',
            self::Candidate => 'Candidate',
        };
    }
}
