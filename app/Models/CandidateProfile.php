<?php

namespace App\Models;

use App\Enums\ExperienceLevel;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class CandidateProfile extends Model
{
    protected $fillable = [
        'user_id', 'headline', 'bio', 'resume_path', 'resume_data',
        'experience_level', 'skills', 'languages',
        'salary_min', 'salary_max', 'salary_currency',
        'availability', 'location', 'remote_ok',
        'linkedin', 'github', 'portfolio', 'telegram',
        'rating_avg', 'rating_count', 'resume_updated_at',
    ];

    protected $casts = [
        'experience_level' => ExperienceLevel::class,
        'skills' => 'array',
        'languages' => 'array',
        'resume_data' => 'array',
        'remote_ok' => 'boolean',
        'rating_avg' => 'decimal:2',
        'salary_min' => 'decimal:2',
        'salary_max' => 'decimal:2',
        'resume_updated_at' => 'datetime',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function reviews(): HasMany
    {
        return $this->hasMany(CandidateReview::class);
    }

    public function recalculateRating(): void
    {
        $reviews = $this->reviews()->where('status', 'published');
        $this->update([
            'rating_avg' => $reviews->avg('overall_rating') ?? 0,
            'rating_count' => $reviews->count(),
        ]);
    }
}
