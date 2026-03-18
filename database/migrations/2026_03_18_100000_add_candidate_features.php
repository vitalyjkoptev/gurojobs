<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // 1. Заметки кандидата к откликам
        Schema::table('job_applications', function (Blueprint $table) {
            $table->text('candidate_notes')->nullable()->after('employer_notes');
        });

        // 2. Последний заход пользователя + дата обновления резюме
        Schema::table('users', function (Blueprint $table) {
            $table->timestamp('last_seen_at')->nullable()->after('status');
        });

        // 3. JSON-данные для билдера резюме + дата обновления
        Schema::table('candidate_profiles', function (Blueprint $table) {
            $table->json('resume_data')->nullable()->after('resume_path');
            $table->timestamp('resume_updated_at')->nullable()->after('rating_count');
        });

        // 4. Таблица жалоб (на вакансии и кандидатов)
        Schema::create('reports', function (Blueprint $table) {
            $table->id();
            $table->foreignId('reporter_id')->constrained('users')->cascadeOnDelete();
            $table->string('reportable_type');       // App\Models\Job, App\Models\User, etc.
            $table->unsignedBigInteger('reportable_id');
            $table->string('reason');                 // spam, inappropriate, fake, harassment, other
            $table->text('description')->nullable();
            $table->json('attachments')->nullable();  // массив путей к фото/видео
            $table->string('status')->default('pending'); // pending, reviewed, resolved, dismissed
            $table->text('admin_notes')->nullable();
            $table->timestamps();

            $table->index(['reportable_type', 'reportable_id']);
            $table->index('status');
        });

        // 5. Таблица сообщений/чатов — добавим поля для пейволла
        // Если таблицы messages нет — создаём
        if (!Schema::hasTable('messages')) {
            Schema::create('messages', function (Blueprint $table) {
                $table->id();
                $table->foreignId('sender_id')->constrained('users')->cascadeOnDelete();
                $table->foreignId('receiver_id')->constrained('users')->cascadeOnDelete();
                $table->foreignId('job_application_id')->nullable()->constrained('job_applications')->nullOnDelete();
                $table->text('body');
                $table->boolean('is_blocked')->default(false); // заблокировано пейволлом
                $table->string('block_reason')->nullable();    // no_plan, contains_contact, contains_link
                $table->timestamp('read_at')->nullable();
                $table->timestamps();

                $table->index(['sender_id', 'receiver_id']);
            });
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('messages');
        Schema::dropIfExists('reports');

        Schema::table('candidate_profiles', function (Blueprint $table) {
            $table->dropColumn(['resume_data', 'resume_updated_at']);
        });

        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('last_seen_at');
        });

        Schema::table('job_applications', function (Blueprint $table) {
            $table->dropColumn('candidate_notes');
        });
    }
};
