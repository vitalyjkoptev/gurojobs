<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class JobCategory extends Model
{
    protected $fillable = ['name', 'slug', 'icon', 'description', 'sort_order'];

    public $timestamps = false;

    public function jobs(): HasMany
    {
        return $this->hasMany(Job::class, 'category_id');
    }

    public function activeJobsCount(): int
    {
        return $this->jobs()->where('status', 'active')->count();
    }
}
