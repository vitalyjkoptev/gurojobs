<?php

namespace App\Models;

use App\Enums\ExperienceLevel;
use App\Enums\JobType;
use App\Enums\WorkMode;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Job extends Model
{
    protected $table = 'job_listings';

    protected $fillable = [
        'company_id', 'user_id',
        'title', 'slug', 'description', 'requirements',
        'category_id', 'experience_level',
        'job_type', 'work_mode',
        'location', 'salary_min', 'salary_max', 'salary_currency',
        'tags', 'keywords',
        'status', 'is_featured', 'is_urgent',
        'views_count', 'clicks_count', 'applications_count',
        'source', 'telegram_message_id',
        'expires_at',
    ];

    protected $casts = [
        'experience_level' => ExperienceLevel::class,
        'job_type' => JobType::class,
        'work_mode' => WorkMode::class,
        'tags' => 'array',
        'keywords' => 'array',
        'is_featured' => 'boolean',
        'is_urgent' => 'boolean',
        'salary_min' => 'decimal:2',
        'salary_max' => 'decimal:2',
        'expires_at' => 'datetime',
    ];

    // ── Scopes ────────────────────────────────────────────────
    public function scopeActive($query) { return $query->where('status', 'active'); }
    public function scopeFeatured($query) { return $query->where('is_featured', true); }
    public function scopeUrgent($query) { return $query->where('is_urgent', true); }

    public function scopeSearch($query, string $keyword)
    {
        return $query->where(function ($q) use ($keyword) {
            $q->where('title', 'like', "%{$keyword}%")
                ->orWhere('description', 'like', "%{$keyword}%")
                ->orWhereJsonContains('tags', $keyword)
                ->orWhereJsonContains('keywords', $keyword);
        });
    }

    public function scopeByLevel($query, ExperienceLevel $level)
    {
        return $query->where('experience_level', $level);
    }

    // ── Relations ─────────────────────────────────────────────
    public function company(): BelongsTo
    {
        return $this->belongsTo(Company::class);
    }

    public function poster(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(JobCategory::class, 'category_id');
    }

    public function applications(): HasMany
    {
        return $this->hasMany(JobApplication::class);
    }

    public function views(): HasMany
    {
        return $this->hasMany(JobView::class);
    }

    public function clicks(): HasMany
    {
        return $this->hasMany(JobClick::class);
    }

    // ── Helpers ───────────────────────────────────────────────
    public function incrementViews(): void
    {
        $this->increment('views_count');
    }

    public function incrementClicks(): void
    {
        $this->increment('clicks_count');
    }

    public function incrementApplications(): void
    {
        $this->increment('applications_count');
    }

    public function salaryRange(): string
    {
        if (!$this->salary_min && !$this->salary_max) return 'Not specified';
        $currency = $this->salary_currency ?? 'USD';
        if ($this->salary_min && $this->salary_max) {
            return "{$currency} " . number_format($this->salary_min) . ' - ' . number_format($this->salary_max);
        }
        return "{$currency} " . number_format($this->salary_min ?: $this->salary_max);
    }
}
