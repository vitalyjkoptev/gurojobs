<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdminSeeder extends Seeder
{
    public function run(): void
    {
        // Only create if admin doesn't exist
        if (!User::where('role', 'admin')->exists()) {
            User::create([
                'name' => env('ADMIN_NAME', 'Admin'),
                'email' => env('ADMIN_EMAIL', 'admin@example.com'),
                'password' => env('ADMIN_PASSWORD', 'ChangeMe2026'),
                'role' => 'admin',
                'status' => 'active',
                'email_verified_at' => now(),
            ]);
        }
    }
}
