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
            'features' => ['Basic search', '1 job post/month'],
        ],
        'starter' => [
            'name' => 'Starter',
            'price' => 49,
            'jobs_per_month' => 10,
            'features' => ['10 jobs/month', 'Basic analytics', 'Email support'],
        ],
        'business' => [
            'name' => 'Business',
            'price' => 149,
            'jobs_per_month' => 50,
            'features' => ['50 jobs/month', 'Full analytics', 'Priority listing', 'Telegram bot'],
        ],
        'enterprise' => [
            'name' => 'Enterprise',
            'price' => 499,
            'jobs_per_month' => -1, // unlimited
            'features' => ['Unlimited jobs', 'API access', 'Dedicated support', 'Custom branding'],
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
