<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class JobClick extends Model
{
    public $timestamps = false;

    protected $fillable = ['job_id', 'user_id', 'click_type', 'ip_address'];

    protected $casts = ['created_at' => 'datetime'];

    protected static function booted(): void
    {
        static::creating(fn($c) => $c->created_at = now());
    }

    public function job(): BelongsTo { return $this->belongsTo(Job::class); }
    public function user(): BelongsTo { return $this->belongsTo(User::class); }
}
