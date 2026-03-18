<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class JobView extends Model
{
    public $timestamps = false;

    protected $fillable = ['job_id', 'user_id', 'ip_address', 'user_agent', 'referer'];

    protected $casts = ['created_at' => 'datetime'];

    protected static function booted(): void
    {
        static::creating(fn($v) => $v->created_at = now());
    }

    public function job(): BelongsTo { return $this->belongsTo(Job::class); }
    public function user(): BelongsTo { return $this->belongsTo(User::class); }
}
