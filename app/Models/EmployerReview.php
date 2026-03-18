<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class EmployerReview extends Model
{
    protected $fillable = [
        'company_id', 'user_id',
        'response_speed', 'hiring_process', 'company_culture',
        'overall_rating', 'comment', 'is_anonymous', 'status',
    ];

    protected $casts = [
        'is_anonymous' => 'boolean',
        'overall_rating' => 'decimal:2',
    ];

    protected static function booted(): void
    {
        static::saving(function ($review) {
            $review->overall_rating = round(
                ($review->response_speed + $review->hiring_process + $review->company_culture) / 3, 2
            );
        });

        static::saved(fn($review) => $review->company->recalculateRating());
    }

    public function company(): BelongsTo { return $this->belongsTo(Company::class); }
    public function reviewer(): BelongsTo { return $this->belongsTo(User::class, 'user_id'); }
}
