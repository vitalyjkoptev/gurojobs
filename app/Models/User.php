<?php

namespace App\Models;

use App\Enums\UserRole;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name', 'email', 'password', 'role',
        'phone', 'avatar', 'telegram_id', 'telegram_username',
        'status', 'company_id', 'last_seen_at', 'onboarded_at',
    ];

    protected $hidden = ['password', 'remember_token'];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
        'role' => UserRole::class,
        'last_seen_at' => 'datetime',
        'onboarded_at' => 'datetime',
    ];

    public function needsOnboarding(): bool
    {
        return $this->onboarded_at === null
            || $this->status === 'pending'
            || empty($this->email);
    }

    // ── Scopes ────────────────────────────────────────────────
    public function scopeAdmins($query) { return $query->where('role', UserRole::Admin); }
    public function scopeEmployers($query) { return $query->where('role', UserRole::Employer); }
    public function scopeCandidates($query) { return $query->where('role', UserRole::Candidate); }
    public function scopeActive($query) { return $query->where('status', 'active'); }

    // ── Checks ────────────────────────────────────────────────
    public function isAdmin(): bool { return $this->role === UserRole::Admin; }
    public function isEmployer(): bool { return $this->role === UserRole::Employer; }
    public function isCandidate(): bool { return $this->role === UserRole::Candidate; }

    // ── Relations ─────────────────────────────────────────────
    public function company(): BelongsTo
    {
        return $this->belongsTo(Company::class);
    }

    public function ownedCompany(): HasOne
    {
        return $this->hasOne(Company::class);
    }

    public function candidateProfile(): HasOne
    {
        return $this->hasOne(CandidateProfile::class);
    }

    public function applications(): HasMany
    {
        return $this->hasMany(JobApplication::class, 'candidate_id');
    }

    public function payments(): HasMany
    {
        return $this->hasMany(Payment::class);
    }

    public function jarvisLogs(): HasMany
    {
        return $this->hasMany(JarvisLog::class);
    }

    public function sentMessages(): HasMany
    {
        return $this->hasMany(Message::class, 'sender_id');
    }

    public function receivedMessages(): HasMany
    {
        return $this->hasMany(Message::class, 'receiver_id');
    }

    public function reports(): HasMany
    {
        return $this->hasMany(Report::class, 'reporter_id');
    }

    /**
     * Проверить, есть ли у пользователя активная подписка (employer → company, candidate → user).
     */
    public function hasActivePlan(): bool
    {
        if ($this->isEmployer() && $this->company) {
            return $this->company->plan !== 'free'
                && $this->company->plan_expires_at
                && $this->company->plan_expires_at->isFuture();
        }

        // Для кандидатов — подписка на пользователя
        $sub = Subscription::where('user_id', $this->id)
            ->where('status', 'active')
            ->where('expires_at', '>', now())
            ->first();

        return $sub !== null;
    }

    /**
     * Текущий план пользователя.
     */
    public function currentPlan(): string
    {
        if ($this->isEmployer() && $this->company) {
            return $this->company->plan ?? 'free';
        }

        $sub = Subscription::where('user_id', $this->id)
            ->where('status', 'active')
            ->where('expires_at', '>', now())
            ->first();

        return $sub ? $sub->plan : 'free';
    }
}
