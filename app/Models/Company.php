<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Company extends Model
{
    protected $fillable = [
        'user_id', 'name', 'slug', 'logo', 'description',
        'website', 'location', 'size', 'founded_year',
        'telegram_channel', 'verified',
        'rating_avg', 'rating_count',
        'plan', 'plan_expires_at',
    ];

    protected $casts = [
        'verified' => 'boolean',
        'rating_avg' => 'decimal:2',
        'plan_expires_at' => 'datetime',
    ];

    public function owner(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function jobs(): HasMany
    {
        return $this->hasMany(Job::class);
    }

    public function reviews(): HasMany
    {
        return $this->hasMany(EmployerReview::class);
    }

    public function subscriptions(): HasMany
    {
        return $this->hasMany(Subscription::class);
    }

    public function activeJobs(): HasMany
    {
        return $this->hasMany(Job::class)->where('status', 'active');
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
