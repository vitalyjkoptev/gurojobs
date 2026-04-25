<?php

use App\Http\Controllers\Admin\AnalyticsController;
use App\Http\Controllers\Admin\CompaniesController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\JobsController as AdminJobsController;
use App\Http\Controllers\Admin\UsersController;
use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Auth\TelegramAuthController;
use App\Http\Controllers\Api\V1\JarvisController;
use App\Http\Controllers\Api\V1\JobsController;
use App\Http\Controllers\Api\V1\ReviewsController;
use App\Http\Controllers\Api\V1\SearchController;
use App\Http\Controllers\Api\V1\TelegramWebhookController;
use App\Http\Controllers\Auth\RecoveryCodeController;
use App\Http\Controllers\Api\V1\MessageController;
use App\Http\Controllers\Api\V1\ReportController;
use App\Http\Controllers\Candidate\ApplicationsController as CandidateApplicationsController;
use App\Http\Controllers\Candidate\ProfileController;
use App\Http\Controllers\Candidate\ResumeController;
use App\Http\Controllers\Employer\ApplicationsController as EmployerApplicationsController;
use App\Http\Controllers\Employer\CompanyProfileController;
use App\Http\Controllers\Employer\JobsController as EmployerJobsController;
use App\Http\Controllers\Payment\CryptoController;
use App\Http\Controllers\Payment\StripeController;
use Illuminate\Support\Facades\Route;

// ── Public ────────────────────────────────────────────────────
Route::prefix('v1')->group(function () {

    // Auth
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);
    Route::post('login/recovery', [RecoveryCodeController::class, 'loginWithCode']);

    // Telegram login (для мобильного клиента: проверяет подпись от Telegram Login Widget)
    Route::post('auth/telegram/callback', [TelegramAuthController::class, 'callback']);

    // Public Jobs
    Route::get('jobs', [JobsController::class, 'index']);
    Route::get('jobs/categories', [JobsController::class, 'categories']);
    Route::get('jobs/positions', [SearchController::class, 'positions']);
    Route::get('jobs/{slug}', [JobsController::class, 'show']);
    Route::post('jobs/{id}/view', [JobsController::class, 'trackView']);
    Route::post('jobs/{id}/click', [JobsController::class, 'trackClick']);

    // Search
    Route::get('search', [SearchController::class, 'search']);
    Route::get('search/suggest', [SearchController::class, 'suggest']);

    // ── Authenticated ────────────────────────────────────────
    Route::middleware('auth:sanctum')->group(function () {

        // Auth
        Route::post('logout', [AuthController::class, 'logout']);
        Route::get('me', [AuthController::class, 'me']);

        // Telegram link / unlink (привязать TG к существующему аккаунту)
        Route::post('auth/telegram/link', [TelegramAuthController::class, 'link']);
        Route::delete('auth/telegram/link', [TelegramAuthController::class, 'unlink']);

        // Recovery Codes
        Route::post('recovery-codes/generate', [RecoveryCodeController::class, 'generate']);
        Route::post('recovery-codes/regenerate', [RecoveryCodeController::class, 'regenerate']);
        Route::get('recovery-codes/status', [RecoveryCodeController::class, 'status']);

        // Passkey / WebAuthn
        if (class_exists(\Laragear\WebAuthn\Http\WebAuthnController::class)) {
            Route::post('webauthn/register/options', [\Laragear\WebAuthn\Http\WebAuthnController::class, 'attestOptions']);
            Route::post('webauthn/register', [\Laragear\WebAuthn\Http\WebAuthnController::class, 'attest']);
            Route::post('webauthn/login/options', [\Laragear\WebAuthn\Http\WebAuthnController::class, 'assertionOptions']);
            Route::post('webauthn/login', [\Laragear\WebAuthn\Http\WebAuthnController::class, 'assert']);
        }

        // Candidate
        Route::prefix('candidate')->group(function () {
            Route::get('profile', [ProfileController::class, 'show']);
            Route::put('profile', [ProfileController::class, 'update']);
            Route::post('apply/{jobId}', [CandidateApplicationsController::class, 'apply']);
            Route::get('applications', [CandidateApplicationsController::class, 'index']);

            // Заметки к откликам
            Route::put('applications/{id}/notes', [CandidateApplicationsController::class, 'updateNotes']);
            Route::delete('applications/{id}/notes', [CandidateApplicationsController::class, 'deleteNotes']);

            // Резюме (билдер + просмотр + PDF)
            Route::get('resume', [ResumeController::class, 'show']);
            Route::put('resume', [ResumeController::class, 'update']);
            Route::get('resume/preview', [ResumeController::class, 'preview']);
            Route::get('resume/pdf', [ResumeController::class, 'downloadPdf']);
            Route::post('resume/upload', [ResumeController::class, 'upload']);
        });

        // Публичные профили (с пейволлом)
        Route::get('candidates/{id}', [ProfileController::class, 'publicProfile']);
        Route::get('employers/{id}', [ProfileController::class, 'recruiterProfile']);

        // Сообщения (с пейволлом)
        Route::prefix('messages')->group(function () {
            Route::get('conversations', [MessageController::class, 'conversations']);
            Route::get('{userId}', [MessageController::class, 'thread']);
            Route::post('/', [MessageController::class, 'send']);
        });

        // Жалобы (report)
        Route::post('reports', [ReportController::class, 'store']);

        // Paywall status
        Route::get('paywall/status', function (\Illuminate\Http\Request $request) {
            $paywall = new \App\Services\Paywall\PaywallService();
            return response()->json([
                'success' => true,
                'data' => $paywall->getPaywallStatus($request->user()),
            ]);
        });

        // Employer
        Route::prefix('employer')->middleware('role:employer,admin')->group(function () {
            Route::apiResource('jobs', EmployerJobsController::class)->names('api.employer.jobs');
            Route::get('jobs/{id}/applications', [EmployerApplicationsController::class, 'index']);
            Route::put('jobs/{jobId}/applications/{appId}', [EmployerApplicationsController::class, 'update']);
            Route::get('company', [CompanyProfileController::class, 'show']);
            Route::put('company', [CompanyProfileController::class, 'update']);
        });

        // Reviews
        Route::post('reviews/employer/{companyId}', [ReviewsController::class, 'reviewEmployer']);
        Route::post('reviews/candidate/{profileId}', [ReviewsController::class, 'reviewCandidate']);
        Route::get('reviews/employer/{companyId}', [ReviewsController::class, 'employerReviews']);
        Route::get('reviews/candidate/{profileId}', [ReviewsController::class, 'candidateReviews']);

        // Payments
        Route::post('payments/stripe/checkout', [StripeController::class, 'checkout']);
        Route::post('payments/crypto/checkout', [CryptoController::class, 'checkout']);

        // Jarvis (admin + employer only)
        Route::middleware('role:admin,employer')->group(function () {
            Route::post('jarvis/command', [JarvisController::class, 'command']);
            Route::get('jarvis/history', [JarvisController::class, 'history']);
        });

        // Admin
        Route::prefix('admin')->middleware('role:admin')->group(function () {
            Route::get('dashboard', [DashboardController::class, 'index']);
            Route::get('analytics', [AnalyticsController::class, 'index']);
            Route::apiResource('users', UsersController::class)->names('api.admin.users');
            Route::apiResource('jobs', AdminJobsController::class)->names('api.admin.jobs');
            Route::apiResource('companies', CompaniesController::class)->names('api.admin.companies');

            // Жалобы (admin)
            Route::get('reports', [ReportController::class, 'index']);
            Route::put('reports/{id}', [ReportController::class, 'update']);
        });
    });

    // Webhooks (no auth)
    Route::post('payments/webhook/stripe', [StripeController::class, 'webhook']);
    Route::post('payments/webhook/crypto', [CryptoController::class, 'webhook']);
    Route::post('telegram/webhook', [TelegramWebhookController::class, 'handle']);
});
