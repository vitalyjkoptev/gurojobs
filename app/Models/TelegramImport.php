<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class TelegramImport extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'channel_id', 'channel_name', 'message_id',
        'raw_text', 'parsed_job_id', 'status',
    ];

    protected $casts = ['created_at' => 'datetime'];

    protected static function booted(): void
    {
        static::creating(fn($i) => $i->created_at = now());
    }

    public function parsedJob(): BelongsTo
    {
        return $this->belongsTo(Job::class, 'parsed_job_id');
    }
}
