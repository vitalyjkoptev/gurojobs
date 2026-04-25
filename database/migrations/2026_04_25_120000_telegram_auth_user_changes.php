<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Email становится nullable — пользователи через Telegram могут не иметь email
        // до прохождения onboarding. UNIQUE сохраняется (MySQL допускает несколько NULL).
        Schema::table('users', function (Blueprint $table) {
            $table->string('email')->nullable()->change();
        });

        // telegram_id: уникальный индекс вместо обычного.
        Schema::table('users', function (Blueprint $table) {
            $table->dropIndex(['telegram_id']);
        });

        Schema::table('users', function (Blueprint $table) {
            $table->unique('telegram_id');
        });

        // Поле для статуса onboarding
        Schema::table('users', function (Blueprint $table) {
            if (!Schema::hasColumn('users', 'onboarded_at')) {
                $table->timestamp('onboarded_at')->nullable()->after('email_verified_at');
            }
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropUnique(['telegram_id']);
            $table->index('telegram_id');
        });

        Schema::table('users', function (Blueprint $table) {
            if (Schema::hasColumn('users', 'onboarded_at')) {
                $table->dropColumn('onboarded_at');
            }
        });

        // email обратно NOT NULL: проставим пустые значения, иначе ALTER упадёт
        DB::table('users')->whereNull('email')->update(['email' => DB::raw("CONCAT('user_', id, '@example.invalid')")]);

        Schema::table('users', function (Blueprint $table) {
            $table->string('email')->nullable(false)->change();
        });
    }
};
