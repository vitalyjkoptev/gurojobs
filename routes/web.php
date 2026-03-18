<?php

use App\Http\Controllers\Admin\WebAdminController;
use App\Http\Controllers\Auth\WebAuthController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\Public\HomeController;
use App\Http\Controllers\Public\JobListController;
use Illuminate\Support\Facades\Route;

// ── Public Pages ─────────────────────────────────────────────
Route::get('/', [HomeController::class, 'index'])->name('home');
Route::get('/jobs', [JobListController::class, 'index'])->name('jobs.index');
Route::get('/jobs/{slug}', [JobListController::class, 'show'])->name('jobs.show');

// Static Pages
Route::get('/about', fn() => view('public.about'))->name('about');
Route::get('/contact', fn() => view('public.contact'))->name('contact');
Route::post('/contact', fn() => back()->with('success', 'Message sent! We will get back to you soon.'))->name('contact.submit');
Route::get('/cv-builder', fn() => view('public.cv-builder'))->name('cv-builder');
Route::get('/for-employers', fn() => view('public.for-employers'))->name('for-employers');
Route::get('/app', fn() => view('public.app'))->name('app.download');

// Legal Pages
Route::get('/terms', fn() => view('public.terms'))->name('terms');
Route::get('/privacy', fn() => view('public.privacy'))->name('privacy');

// ── Auth (Guest only) ───────────────────────────────────────
Route::middleware('guest')->group(function () {
    Route::get('/login', [WebAuthController::class, 'showLogin'])->name('login');
    Route::post('/login', [WebAuthController::class, 'login']);
    Route::get('/register', [WebAuthController::class, 'showRegister'])->name('register');
    Route::post('/register', [WebAuthController::class, 'register']);
    Route::get('/demo-login', [WebAuthController::class, 'demoLogin'])->name('demo.login'); // TODO: remove
});

// ── Authenticated ───────────────────────────────────────────
Route::middleware('auth')->group(function () {
    Route::post('/logout', [WebAuthController::class, 'logout'])->name('logout');
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');
});

// ── Admin Panel ────────────────────────────────────────────
Route::middleware(['auth', 'role:admin'])->prefix('admin')->name('admin.')->group(function () {
    Route::get('/', [WebAdminController::class, 'dashboard'])->name('dashboard');
    Route::get('/users', [WebAdminController::class, 'users'])->name('users');
    Route::get('/jobs', [WebAdminController::class, 'jobs'])->name('jobs');
    Route::get('/companies', [WebAdminController::class, 'companies'])->name('companies');
    Route::get('/applications', [WebAdminController::class, 'applications'])->name('applications');
    Route::get('/categories', [WebAdminController::class, 'categories'])->name('categories');
    Route::get('/payments', [WebAdminController::class, 'payments'])->name('payments');
    Route::get('/subscriptions', [WebAdminController::class, 'subscriptions'])->name('subscriptions');
    Route::get('/settings', [WebAdminController::class, 'settings'])->name('settings');
    Route::get('/faqs', [WebAdminController::class, 'faqs'])->name('faqs');
    Route::get('/search', [WebAdminController::class, 'search'])->name('search');
    Route::get('/profile', [WebAdminController::class, 'profile'])->name('profile');
    Route::get('/profile/projects', [WebAdminController::class, 'profileProjects'])->name('profile.projects');
    Route::get('/profile/connections', [WebAdminController::class, 'profileConnections'])->name('profile.connections');
});
