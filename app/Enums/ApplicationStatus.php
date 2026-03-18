<?php

namespace App\Enums;

enum ApplicationStatus: string
{
    case Pending = 'pending';
    case Reviewed = 'reviewed';
    case Shortlisted = 'shortlisted';
    case Rejected = 'rejected';
    case Hired = 'hired';

    public function label(): string
    {
        return match ($this) {
            self::Pending => 'Pending',
            self::Reviewed => 'Reviewed',
            self::Shortlisted => 'Shortlisted',
            self::Rejected => 'Rejected',
            self::Hired => 'Hired',
        };
    }
}
