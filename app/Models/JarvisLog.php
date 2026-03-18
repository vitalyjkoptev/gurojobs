<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class JarvisLog extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'user_id',
        'command_text',
        'command_type',
        'intent',
        'response_text',
        'action_taken',
        'success',
    ];

    protected $casts = [
        'success' => 'boolean',
        'created_at' => 'datetime',
    ];

    protected static function booted(): void
    {
        static::creating(function ($log) {
            $log->created_at = now();
        });
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
