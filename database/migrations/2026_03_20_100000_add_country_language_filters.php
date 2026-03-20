<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('candidate_profiles', function (Blueprint $table) {
            // Язык общения
            $table->string('communication_language_priority', 10)->nullable()->after('languages'); // en, de, pl, ru, uk...
            $table->json('communication_languages_acceptable')->nullable()->after('communication_language_priority'); // ["en","de"]

            // Гражданство
            $table->string('citizenship_country', 100)->nullable()->after('location'); // "Poland", "Germany"
            $table->boolean('in_citizenship_country')->nullable()->after('citizenship_country'); // true/false

            // Отсечь страны компаний (не хочу работать в)
            $table->json('blocked_company_countries')->nullable()->after('in_citizenship_country'); // ["Russia","Belarus"]
        });

        Schema::table('companies', function (Blueprint $table) {
            // Язык общения
            $table->string('communication_language_priority', 10)->nullable()->after('location'); // en, de, pl...
            $table->json('communication_languages_acceptable')->nullable()->after('communication_language_priority'); // ["en","de"]

            // Страна главного офиса (может быть несколько)
            $table->json('main_office_countries')->nullable()->after('communication_languages_acceptable'); // ["Malta","Cyprus"]

            // Отсечь гражданства кандидатов
            $table->json('blocked_candidate_citizenships')->nullable()->after('main_office_countries'); // ["Russia","Belarus"]

            // Показать кандидатов за пределами страны гражданства
            $table->string('candidate_location_pref', 20)->default('all')->after('blocked_candidate_citizenships');
            // "outside" = только за пределами, "all" = все варианты
        });
    }

    public function down(): void
    {
        Schema::table('candidate_profiles', function (Blueprint $table) {
            $table->dropColumn([
                'communication_language_priority',
                'communication_languages_acceptable',
                'citizenship_country',
                'in_citizenship_country',
                'blocked_company_countries',
            ]);
        });

        Schema::table('companies', function (Blueprint $table) {
            $table->dropColumn([
                'communication_language_priority',
                'communication_languages_acceptable',
                'main_office_countries',
                'blocked_candidate_citizenships',
                'candidate_location_pref',
            ]);
        });
    }
};
