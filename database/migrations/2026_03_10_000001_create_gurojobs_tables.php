<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // ── Companies (MUST be before users extension due to FK) ─
        Schema::create('companies', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id')->index(); // FK added after users table exists
            $table->string('name');
            $table->string('slug')->unique();
            $table->string('logo')->nullable();
            $table->text('description')->nullable();
            $table->string('website')->nullable();
            $table->string('location')->nullable();
            $table->string('size')->nullable(); // 1-10, 11-50, 51-200, 201-500, 500+
            $table->year('founded_year')->nullable();
            $table->string('telegram_channel')->nullable();
            $table->boolean('verified')->default(false);
            $table->decimal('rating_avg', 3, 2)->default(0);
            $table->unsignedInteger('rating_count')->default(0);
            $table->string('plan')->default('free'); // free, starter, business, enterprise
            $table->timestamp('plan_expires_at')->nullable();
            $table->timestamps();

            $table->index('slug');
            $table->index('plan');
        });

        // ── Extend users table ───────────────────────────────────
        Schema::table('users', function (Blueprint $table) {
            $table->string('role')->default('candidate')->after('password');
            $table->string('phone')->nullable()->after('role');
            $table->string('avatar')->nullable()->after('phone');
            $table->string('telegram_id')->nullable()->after('avatar');
            $table->string('telegram_username')->nullable()->after('telegram_id');
            $table->string('status')->default('active')->after('telegram_username');
            $table->foreignId('company_id')->nullable()->after('status')->constrained('companies')->nullOnDelete();
            $table->text('recovery_codes')->nullable()->after('company_id');
            $table->timestamp('recovery_codes_generated_at')->nullable()->after('recovery_codes');

            $table->index('role');
            $table->index('status');
            $table->index('telegram_id');
        });

        // ── Candidate Profiles ───────────────────────────────────
        Schema::create('candidate_profiles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('headline')->nullable();
            $table->text('bio')->nullable();
            $table->string('resume_path')->nullable();
            $table->string('experience_level')->nullable(); // c-level, head, senior, middle, junior
            $table->json('skills')->nullable();
            $table->json('languages')->nullable();
            $table->decimal('salary_min', 10, 2)->nullable();
            $table->decimal('salary_max', 10, 2)->nullable();
            $table->string('salary_currency', 10)->default('USD');
            $table->string('availability')->default('actively_looking'); // actively_looking, open, not_looking
            $table->string('location')->nullable();
            $table->boolean('remote_ok')->default(true);
            $table->string('linkedin')->nullable();
            $table->string('github')->nullable();
            $table->string('portfolio')->nullable();
            $table->string('telegram')->nullable();
            $table->decimal('rating_avg', 3, 2)->default(0);
            $table->unsignedInteger('rating_count')->default(0);
            $table->timestamps();

            $table->index('experience_level');
            $table->index('availability');
        });

        // ── Job Categories ───────────────────────────────────────
        Schema::create('job_categories', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('slug')->unique();
            $table->string('icon')->nullable();
            $table->text('description')->nullable();
            $table->unsignedInteger('sort_order')->default(0);
        });

        // ── Jobs (Vacancies) ─────────────────────────────────────
        Schema::create('job_listings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('company_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('title');
            $table->string('slug')->unique();
            $table->text('description');
            $table->text('requirements')->nullable();
            $table->foreignId('category_id')->nullable()->constrained('job_categories')->nullOnDelete();
            $table->string('experience_level')->nullable(); // c-level, head, senior, middle, junior
            $table->string('job_type')->default('full-time'); // full-time, part-time, contract, freelance
            $table->string('work_mode')->default('remote'); // remote, on-site, hybrid
            $table->string('location')->nullable();
            $table->decimal('salary_min', 10, 2)->nullable();
            $table->decimal('salary_max', 10, 2)->nullable();
            $table->string('salary_currency', 10)->default('USD');
            $table->json('tags')->nullable();
            $table->json('keywords')->nullable();
            $table->string('status')->default('draft'); // active, paused, closed, draft
            $table->boolean('is_featured')->default(false);
            $table->boolean('is_urgent')->default(false);
            $table->unsignedInteger('views_count')->default(0);
            $table->unsignedInteger('clicks_count')->default(0);
            $table->unsignedInteger('applications_count')->default(0);
            $table->string('source')->default('web'); // web, telegram, api
            $table->string('telegram_message_id')->nullable();
            $table->timestamp('expires_at')->nullable();
            $table->timestamps();

            $table->index('status');
            $table->index('experience_level');
            $table->index('job_type');
            $table->index('work_mode');
            $table->index(['is_featured', 'status']);
            // $table->fullText(['title', 'description']); // Enable on MySQL
        });

        // ── Job Applications ─────────────────────────────────────
        Schema::create('job_applications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('job_id')->constrained('job_listings')->cascadeOnDelete();
            $table->foreignId('candidate_id')->constrained('users')->cascadeOnDelete();
            $table->text('cover_letter')->nullable();
            $table->string('resume_path')->nullable();
            $table->string('status')->default('pending'); // pending, reviewed, shortlisted, rejected, hired
            $table->text('employer_notes')->nullable();
            $table->timestamps();

            $table->unique(['job_id', 'candidate_id']);
            $table->index('status');
        });

        // ── Job Views ────────────────────────────────────────────
        Schema::create('job_views', function (Blueprint $table) {
            $table->id();
            $table->foreignId('job_id')->constrained('job_listings')->cascadeOnDelete();
            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete();
            $table->string('ip_address', 45)->nullable();
            $table->string('user_agent')->nullable();
            $table->string('referer')->nullable();
            $table->timestamp('created_at');

            $table->index(['job_id', 'created_at']);
        });

        // ── Job Clicks ───────────────────────────────────────────
        Schema::create('job_clicks', function (Blueprint $table) {
            $table->id();
            $table->foreignId('job_id')->constrained('job_listings')->cascadeOnDelete();
            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete();
            $table->string('click_type')->default('apply'); // apply, company, contact
            $table->string('ip_address', 45)->nullable();
            $table->timestamp('created_at');

            $table->index(['job_id', 'click_type']);
        });

        // ── Employer Reviews ─────────────────────────────────────
        Schema::create('employer_reviews', function (Blueprint $table) {
            $table->id();
            $table->foreignId('company_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->unsignedTinyInteger('response_speed'); // 1-5
            $table->unsignedTinyInteger('hiring_process'); // 1-5
            $table->unsignedTinyInteger('company_culture'); // 1-5
            $table->decimal('overall_rating', 3, 2);
            $table->text('comment')->nullable();
            $table->boolean('is_anonymous')->default(false);
            $table->string('status')->default('pending'); // published, pending, hidden
            $table->timestamps();

            $table->unique(['company_id', 'user_id']);
            $table->index('status');
        });

        // ── Candidate Reviews ────────────────────────────────────
        Schema::create('candidate_reviews', function (Blueprint $table) {
            $table->id();
            $table->foreignId('candidate_profile_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->unsignedTinyInteger('communication'); // 1-5
            $table->unsignedTinyInteger('skills_match'); // 1-5
            $table->unsignedTinyInteger('professionalism'); // 1-5
            $table->decimal('overall_rating', 3, 2);
            $table->text('comment')->nullable();
            $table->string('status')->default('pending');
            $table->timestamps();

            $table->unique(['candidate_profile_id', 'user_id']);
        });

        // ── Payments ─────────────────────────────────────────────
        Schema::create('payments', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('type'); // subscription, one-time
            $table->string('plan')->nullable();
            $table->decimal('amount', 10, 2);
            $table->string('currency', 10)->default('USD');
            $table->string('payment_method'); // stripe, crypto, apple_pay, google_pay
            $table->string('payment_id')->nullable(); // external payment ID
            $table->string('status')->default('pending'); // pending, completed, failed, refunded
            $table->json('meta')->nullable();
            $table->timestamps();

            $table->index('status');
            $table->index('payment_method');
        });

        // ── Subscriptions ────────────────────────────────────────
        Schema::create('subscriptions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('company_id')->nullable()->constrained()->nullOnDelete();
            $table->string('plan');
            $table->timestamp('starts_at');
            $table->timestamp('expires_at');
            $table->string('status')->default('active'); // active, cancelled, expired
            $table->string('payment_id')->nullable();
            $table->timestamps();

            $table->index(['status', 'expires_at']);
        });

        // ── Telegram Imports ─────────────────────────────────────
        Schema::create('telegram_imports', function (Blueprint $table) {
            $table->id();
            $table->string('channel_id');
            $table->string('channel_name')->nullable();
            $table->string('message_id');
            $table->text('raw_text');
            $table->foreignId('parsed_job_id')->nullable()->constrained('job_listings')->nullOnDelete();
            $table->string('status')->default('pending'); // pending, parsed, failed, skipped
            $table->timestamp('created_at');

            $table->unique(['channel_id', 'message_id']);
            $table->index('status');
        });

        // ── Notifications ────────────────────────────────────────
        Schema::create('guro_notifications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('type');
            $table->string('title');
            $table->text('body')->nullable();
            $table->json('data')->nullable();
            $table->string('channel')->default('in-app'); // email, telegram, push, in-app
            $table->timestamp('read_at')->nullable();
            $table->timestamp('created_at');

            $table->index(['user_id', 'read_at']);
        });

        // ── Jarvis Logs ──────────────────────────────────────────
        Schema::create('jarvis_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->text('command_text');
            $table->string('command_type')->default('text'); // voice, text
            $table->string('intent')->nullable();
            $table->text('response_text')->nullable();
            $table->string('action_taken')->nullable();
            $table->boolean('success')->default(false);
            $table->timestamp('created_at');

            $table->index(['user_id', 'created_at']);
        });

        // ── iGaming Positions Dictionary ─────────────────────────
        Schema::create('igaming_positions', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->string('category_slug');
            $table->string('experience_level'); // c-level, head, senior, middle, junior
            $table->text('aliases')->nullable(); // comma-separated aliases for search
            $table->timestamp('created_at')->nullable();

            $table->index('category_slug');
            $table->index('experience_level');
            // $table->fullText(['title', 'aliases']); // Enable on MySQL
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('igaming_positions');
        Schema::dropIfExists('jarvis_logs');
        Schema::dropIfExists('guro_notifications');
        Schema::dropIfExists('telegram_imports');
        Schema::dropIfExists('subscriptions');
        Schema::dropIfExists('payments');
        Schema::dropIfExists('candidate_reviews');
        Schema::dropIfExists('employer_reviews');
        Schema::dropIfExists('job_clicks');
        Schema::dropIfExists('job_views');
        Schema::dropIfExists('job_applications');
        Schema::dropIfExists('job_listings');
        Schema::dropIfExists('job_categories');
        Schema::dropIfExists('candidate_profiles');
        Schema::dropIfExists('companies');

        Schema::table('users', function (Blueprint $table) {
            $table->dropIndex(['role']);
            $table->dropIndex(['status']);
            $table->dropIndex(['telegram_id']);
            $table->dropColumn([
                'role', 'phone', 'avatar', 'telegram_id', 'telegram_username',
                'status', 'company_id', 'recovery_codes', 'recovery_codes_generated_at',
            ]);
        });
    }
};
