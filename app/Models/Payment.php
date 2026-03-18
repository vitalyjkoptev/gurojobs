<?php

namespace App\Models;

use App\Enums\PaymentMethod;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Payment extends Model
{
    protected $fillable = [
        'user_id', 'type', 'plan', 'amount', 'currency',
        'payment_method', 'payment_id', 'status', 'meta',
    ];

    protected $casts = [
        'payment_method' => PaymentMethod::class,
        'amount' => 'decimal:2',
        'meta' => 'array',
    ];

    public function user(): BelongsTo { return $this->belongsTo(User::class); }

    public function scopeCompleted($query) { return $query->where('status', 'completed'); }
    public function scopePending($query) { return $query->where('status', 'pending'); }
}
