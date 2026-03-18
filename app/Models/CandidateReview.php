<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CandidateReview extends Model
{
    protected $fillable = [
        'candidate_profile_id', 'user_id',
        'communication', 'skills_match', 'professionalism',
        'overall_rating', 'comment', 'status',
    ];

    protected $casts = [
        'overall_rating' => 'decimal:2',
    ];

    protected static function booted(): void
    {
        static::saving(function ($review) {
            $review->overall_rating = round(
                ($review->communication + $review->skills_match + $review->professionalism) / 3, 2
            );
        });

        static::saved(fn($review) => $review->candidateProfile->recalculateRating());
    }

    public function candidateProfile(): BelongsTo { return $this->belongsTo(CandidateProfile::class); }
    public function reviewer(): BelongsTo { return $this->belongsTo(User::class, 'user_id'); }
}
