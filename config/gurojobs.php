<?php

return [
    /*
    |--------------------------------------------------------------------------
    | GURO JOBS Configuration
    |--------------------------------------------------------------------------
    */

    'name' => env('APP_NAME', 'GURO JOBS'),
    'tagline' => 'iGaming Jobs Portal',

    /*
    |--------------------------------------------------------------------------
    | Jarvis AI Assistant
    |--------------------------------------------------------------------------
    */
    'jarvis' => [
        'enabled' => env('JARVIS_ENABLED', true),
        'ai_enabled' => env('JARVIS_AI_ENABLED', true),
        'api_key' => env('JARVIS_API_KEY', env('ANTHROPIC_API_KEY')),
        'model' => env('JARVIS_MODEL', 'claude-sonnet-4-6'),
        'max_history' => env('JARVIS_MAX_HISTORY', 100),
    ],

    /*
    |--------------------------------------------------------------------------
    | Telegram Integration
    |--------------------------------------------------------------------------
    */
    'telegram' => [
        'bot_token' => env('TELEGRAM_BOT_TOKEN'),
        'webhook_url' => env('TELEGRAM_WEBHOOK_URL'),
        'community_channels' => explode(',', env('TELEGRAM_CHANNELS', '')),
    ],

    /*
    |--------------------------------------------------------------------------
    | Payments
    |--------------------------------------------------------------------------
    */
    'payments' => [
        'stripe' => [
            'key' => env('STRIPE_KEY'),
            'secret' => env('STRIPE_SECRET'),
            'webhook_secret' => env('STRIPE_WEBHOOK_SECRET'),
        ],
        'crypto' => [
            'provider' => env('CRYPTO_PROVIDER', 'nowpayments'),
            'api_key' => env('NOWPAYMENTS_API_KEY'),
            'ipn_secret' => env('NOWPAYMENTS_IPN_SECRET'),
            'accepted_currencies' => ['usdt', 'usdc', 'btc', 'eth'],
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Plans & Pricing (USD)
    |--------------------------------------------------------------------------
    */
    'plans' => [
        'free' => [
            'name' => 'Free',
            'price' => 0,
            'jobs_per_month' => 1,
            'contacts_per_day' => 0,
            'team_members' => 1,
            'telegram_notifications' => false,
            'features' => ['Basic search', '1 job post/month'],
        ],
        'basic' => [
            'name' => 'Basic',
            'price' => 10,
            'jobs_per_month' => 5,
            'contacts_per_day' => 10,
            'team_members' => 1,
            'telegram_notifications' => false,
            'trial_days' => 20,
            'features' => ['5 jobs/month', '10 contact reveals/day', 'Basic analytics', 'Email support'],
        ],
        'premium' => [
            'name' => 'Premium',
            'price' => 35,
            'jobs_per_month' => 25,
            'contacts_per_day' => 50,
            'team_members' => 3,
            'telegram_notifications' => false,
            'linkedin_access' => true,
            'features' => ['25 jobs/month', '50 contacts/day', 'Team up to 3', 'LinkedIn profiles', 'Full analytics', 'Priority listing'],
        ],
        'vip' => [
            'name' => 'VIP',
            'price' => 65,
            'jobs_per_month' => -1,
            'contacts_per_day' => -1,
            'team_members' => 5,
            'telegram_notifications' => true,
            'linkedin_access' => true,
            'features' => ['Unlimited jobs', 'Unlimited contacts', 'Team up to 5', 'LinkedIn profiles', 'Telegram notifications', 'Dedicated support', 'API access'],
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Experience Levels
    |--------------------------------------------------------------------------
    */
    'experience_levels' => [
        'c-level' => 'C-Level',
        'head' => 'Head',
        'senior' => 'Senior',
        'middle' => 'Middle',
        'junior' => 'Junior',
    ],

    /*
    |--------------------------------------------------------------------------
    | Platforms
    |--------------------------------------------------------------------------
    */
    'platforms' => [
        'web' => true,           // Website (gurojobs.com)
        'admin' => true,         // Admin panel (web)
        'mobile_boss' => true,   // Mobile app for boss/admin
        'mobile_client' => true, // Mobile app for employer/candidate
    ],
];
