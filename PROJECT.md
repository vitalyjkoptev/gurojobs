# GURO JOBS - iGaming Job Portal

## Overview
Job portal for the iGaming industry with Telegram community integration, AI-powered search, rating system, and multi-payment support. Built on the same template as WinCaseJobs.

## Tech Stack
- **Backend:** Laravel 12 (PHP 8.4)
- **Frontend:** Bootstrap 5 + Blade (WinCaseJobs template)
- **Database:** MySQL 8
- **Cache/Queue:** Redis
- **Search:** Laravel Scout + Meilisearch
- **Payments:** Stripe (cards), Crypto (USDT/USDC via NOWPayments), Mobile wallets (Apple Pay, Google Pay via Stripe)
- **Telegram:** Telegram Bot API + Webhook
- **Voice Agent:** Jarvis (Web Speech API + Claude AI)
- **Auth:** Laravel Sanctum + WebAuthn (Passkey/FaceID/TouchID) + Password fallback + Recovery codes
- **Mobile:** Flutter 3.x (2 apps — Boss + Client)

## Color Scheme (from WinCaseJobs)
- **Primary:** #015EA7 (Blue)
- **Theme:** Professional Blue
- **Background:** #FFFFFF
- **Text:** #333333
- **Accent:** Определится при интеграции шаблона

## User Roles (Single Login Form)
| Role | Description |
|------|-------------|
| admin | Full system access, moderation, analytics |
| employer | Post jobs, view candidates, manage company profile |
| candidate | Search jobs, apply, manage resume/profile |

## Core Features

### 1. Authentication & Registration
- Single login/register form for all roles (admin/employer/candidate)
- **Multi-factor auth flow:**
  1. Email → Auto-offer Passkey setup
  2. Passkey (FaceID / TouchID / Windows Hello) — primary
  3. Hardware key (YubiKey) — optional
  4. Password fallback — classic login
  5. Recovery codes — backup access
- Email registration + verification
- Telegram OAuth login
- Role selection during registration (employer/candidate)
- Admin accounts created via seeder only
- WebAuthn API (via `laragear/webauthn` package for Laravel 12)

### 2. Job Listings (Vacancies)
- Post from admin panel or via Telegram bot
- Telegram community integration (auto-import vacancies from Telegram channels)
- Job fields:
  - Title, Description, Requirements
  - Company, Location (remote/on-site/hybrid)
  - Salary range (USD/EUR/Crypto)
  - Experience level: **C-Level, Head, Senior, Middle, Junior**
  - Job type: Full-time, Part-time, Contract, Freelance
  - iGaming category (see categories below)
  - Tags/Keywords (free text, searchable)
  - Status: active/paused/closed
  - Views count, Clicks count, Applications count

### 3. iGaming Job Categories
- Casino Operations
- Sports Betting
- Poker
- eSports
- Game Development (Slots, Table Games, Live Casino)
- Affiliate & Marketing
- Compliance & Legal
- Risk & Fraud
- Payment & Fintech
- Customer Support
- IT & Infrastructure
- Product & UX
- Data & Analytics
- HR & Recruitment
- C-Level / Executive

### 4. Keyword Search (Smart Search)
- **User types any keyword** (e.g. "CMO", "slot developer", "compliance")
- Full-text search across: job title, description, tags, company name
- Auto-highlight matching terms in results
- Search suggestions / autocomplete
- Filter by:
  - Experience level (C-Level / Head / Senior / Middle / Junior)
  - Category
  - Location
  - Salary range
  - Job type
  - Remote/On-site/Hybrid
- Sort by: relevance, date, salary, views

### 5. Candidate Profiles (Anketa)
- Personal info (name, email, phone, location)
- Photo/avatar
- Resume/CV upload (PDF)
- Experience level
- Skills & technologies (tags)
- Work history
- Salary expectations
- Availability status (actively looking / open to offers / not looking)
- Portfolio links (LinkedIn, GitHub, etc.)
- Telegram handle

### 6. Analytics & Tracking
- **Job views count** (unique + total)
- **Click tracking** (who clicked on which job/employer)
- **Application tracking** (who applied where)
- **Employer dashboard:**
  - Views per job
  - Click-through rate
  - Applications received
  - Candidate quality metrics
- **Admin dashboard:**
  - Total jobs, users, applications
  - Daily/weekly/monthly stats
  - Popular categories
  - Top employers
  - Revenue analytics

### 7. Rating System
- **Employer rating** (by candidates):
  - Response speed (1-5)
  - Hiring process (1-5)
  - Company culture (1-5)
  - Overall rating (computed)
  - Text review
- **Candidate rating** (by employers):
  - Communication (1-5)
  - Skills match (1-5)
  - Professionalism (1-5)
  - Overall rating (computed)
  - Text review
- Ratings visible on profiles
- Minimum 3 reviews to show rating

### 8. Payment System
- **Stripe** - Credit/Debit cards
- **Stripe** - Apple Pay / Google Pay (mobile wallets)
- **NOWPayments** - USDT, USDC, BTC, ETH
- **Payment plans:**
  - Free: 1 job post/month, basic search
  - Starter: 10 jobs/month, analytics ($49/mo)
  - Business: 50 jobs/month, full analytics, priority listing ($149/mo)
  - Enterprise: Unlimited, API access, dedicated support ($499/mo)
- **One-time purchases:**
  - Featured job listing ($29)
  - Urgent hiring badge ($19)
  - Resume boost for candidates ($9)

### 9. Telegram Integration
- Bot for employers: post jobs via Telegram
- Bot for candidates: job alerts, search, apply
- Auto-import from configured Telegram channels/groups
- Notification delivery via Telegram
- Telegram login (one-click)

### 10. Jarvis - AI Master Agent (Voice Control)
- Voice-controlled admin/management panel
- Web Speech API (browser-native) for voice input
- AI processing via Claude/OpenAI API
- Commands:
  - "Show me today's statistics"
  - "How many new applications today?"
  - "Post a new job for Senior Slot Developer"
  - "Block user [name]"
  - "Show top employers this week"
  - "Generate report for last month"
- Text-to-Speech responses
- Dashboard widget with Jarvis UI
- Wake word: "Jarvis" or push-to-talk button
- Command history & logs

---

## Database Schema

### Tables

```
users
├── id, name, email, password, role (admin/employer/candidate)
├── phone, avatar, telegram_id, telegram_username
├── email_verified_at, status (active/banned/pending)
├── company_id (nullable, for employers)
├── created_at, updated_at

companies
├── id, user_id (owner), name, slug, logo, description
├── website, location, size, founded_year
├── telegram_channel, verified (bool)
├── rating_avg, rating_count
├── plan (free/starter/business/enterprise), plan_expires_at
├── created_at, updated_at

candidate_profiles
├── id, user_id, headline, bio, resume_path
├── experience_level (c-level/head/senior/middle/junior)
├── skills (JSON), languages (JSON)
├── salary_min, salary_max, salary_currency
├── availability (actively_looking/open/not_looking)
├── location, remote_ok (bool)
├── linkedin, github, portfolio, telegram
├── rating_avg, rating_count
├── created_at, updated_at

jobs
├── id, company_id, user_id (poster)
├── title, slug, description, requirements
├── category_id, experience_level
├── job_type (full-time/part-time/contract/freelance)
├── work_mode (remote/on-site/hybrid)
├── location, salary_min, salary_max, salary_currency
├── tags (JSON), keywords (JSON)
├── status (active/paused/closed/draft)
├── is_featured, is_urgent
├── views_count, clicks_count, applications_count
├── source (web/telegram/api)
├── telegram_message_id
├── expires_at, created_at, updated_at

job_categories
├── id, name, slug, icon, description, sort_order

job_applications
├── id, job_id, candidate_id (user_id)
├── cover_letter, resume_path
├── status (pending/reviewed/shortlisted/rejected/hired)
├── employer_notes
├── created_at, updated_at

job_views
├── id, job_id, user_id (nullable), ip_address
├── user_agent, referer, created_at

job_clicks
├── id, job_id, user_id (nullable), click_type (apply/company/contact)
├── ip_address, created_at

employer_reviews
├── id, company_id, user_id (reviewer - candidate)
├── response_speed, hiring_process, company_culture
├── overall_rating, comment, is_anonymous
├── status (published/pending/hidden)
├── created_at, updated_at

candidate_reviews
├── id, candidate_profile_id, user_id (reviewer - employer)
├── communication, skills_match, professionalism
├── overall_rating, comment
├── status (published/pending/hidden)
├── created_at, updated_at

payments
├── id, user_id, type (subscription/one-time)
├── plan, amount, currency
├── payment_method (stripe/crypto/apple_pay/google_pay)
├── payment_id (external), status (pending/completed/failed/refunded)
├── meta (JSON)
├── created_at, updated_at

subscriptions
├── id, user_id, company_id, plan
├── starts_at, expires_at, status (active/cancelled/expired)
├── payment_id, created_at, updated_at

telegram_imports
├── id, channel_id, channel_name, message_id
├── raw_text, parsed_job_id (nullable)
├── status (pending/parsed/failed/skipped)
├── created_at

notifications
├── id, user_id, type, title, body
├── data (JSON), channel (email/telegram/push/in-app)
├── read_at, created_at

jarvis_logs
├── id, user_id, command_text, command_type (voice/text)
├── intent, response_text, action_taken
├── success (bool), created_at
```

---

## Directory Structure

```
gurojobs/
├── app/
│   ├── Console/Commands/
│   │   ├── ImportTelegramJobs.php
│   │   └── ProcessJarvisCommand.php
│   ├── Events/
│   │   ├── JobViewed.php
│   │   ├── JobClicked.php
│   │   └── ApplicationSubmitted.php
│   ├── Http/
│   │   ├── Controllers/
│   │   │   ├── Auth/
│   │   │   │   ├── LoginController.php
│   │   │   │   ├── RegisterController.php
│   │   │   │   └── TelegramAuthController.php
│   │   │   ├── Admin/
│   │   │   │   ├── DashboardController.php
│   │   │   │   ├── JobsController.php
│   │   │   │   ├── UsersController.php
│   │   │   │   ├── CompaniesController.php
│   │   │   │   ├── PaymentsController.php
│   │   │   │   └── AnalyticsController.php
│   │   │   ├── Employer/
│   │   │   │   ├── DashboardController.php
│   │   │   │   ├── JobsController.php
│   │   │   │   ├── ApplicationsController.php
│   │   │   │   └── CompanyProfileController.php
│   │   │   ├── Candidate/
│   │   │   │   ├── DashboardController.php
│   │   │   │   ├── ProfileController.php
│   │   │   │   ├── ApplicationsController.php
│   │   │   │   └── SearchController.php
│   │   │   ├── Api/
│   │   │   │   ├── V1/
│   │   │   │   │   ├── AuthController.php
│   │   │   │   │   ├── JobsController.php
│   │   │   │   │   ├── SearchController.php
│   │   │   │   │   ├── JarvisController.php
│   │   │   │   │   └── WebhookController.php
│   │   │   ├── Public/
│   │   │   │   ├── HomeController.php
│   │   │   │   ├── JobListController.php
│   │   │   │   └── CompanyController.php
│   │   │   └── Payment/
│   │   │       ├── StripeController.php
│   │   │       └── CryptoController.php
│   │   └── Middleware/
│   │       ├── RoleMiddleware.php
│   │       └── TrackJobView.php
│   ├── Models/
│   │   ├── User.php
│   │   ├── Company.php
│   │   ├── CandidateProfile.php
│   │   ├── Job.php
│   │   ├── JobCategory.php
│   │   ├── JobApplication.php
│   │   ├── JobView.php
│   │   ├── JobClick.php
│   │   ├── EmployerReview.php
│   │   ├── CandidateReview.php
│   │   ├── Payment.php
│   │   ├── Subscription.php
│   │   ├── TelegramImport.php
│   │   ├── Notification.php
│   │   └── JarvisLog.php
│   ├── Services/
│   │   ├── Search/
│   │   │   └── JobSearchService.php
│   │   ├── Telegram/
│   │   │   ├── TelegramBotService.php
│   │   │   └── TelegramImportService.php
│   │   ├── Payment/
│   │   │   ├── StripeService.php
│   │   │   └── CryptoPaymentService.php
│   │   ├── Rating/
│   │   │   └── RatingService.php
│   │   ├── Analytics/
│   │   │   └── AnalyticsService.php
│   │   └── Jarvis/
│   │       ├── JarvisService.php
│   │       ├── IntentParser.php
│   │       └── CommandExecutor.php
│   └── Enums/
│       ├── UserRole.php
│       ├── ExperienceLevel.php
│       ├── JobType.php
│       ├── WorkMode.php
│       ├── ApplicationStatus.php
│       └── PaymentMethod.php
├── config/
│   ├── gurojobs.php
│   ├── payments.php
│   └── telegram.php
├── database/
│   ├── migrations/
│   └── seeders/
│       ├── DatabaseSeeder.php
│       ├── AdminSeeder.php
│       ├── JobCategorySeeder.php
│       └── DemoDataSeeder.php
├── resources/
│   ├── views/
│   │   ├── layouts/
│   │   │   ├── app.blade.php (main layout - WinCaseJobs template)
│   │   │   ├── admin.blade.php
│   │   │   ├── employer.blade.php
│   │   │   └── candidate.blade.php
│   │   ├── auth/
│   │   │   ├── login.blade.php (single form)
│   │   │   ├── register.blade.php
│   │   │   └── verify-email.blade.php
│   │   ├── public/
│   │   │   ├── home.blade.php
│   │   │   ├── jobs.blade.php
│   │   │   ├── job-detail.blade.php
│   │   │   ├── companies.blade.php
│   │   │   └── company-detail.blade.php
│   │   ├── admin/
│   │   ├── employer/
│   │   ├── candidate/
│   │   ├── jarvis/
│   │   │   └── panel.blade.php
│   │   └── components/
│   │       ├── search-bar.blade.php
│   │       ├── job-card.blade.php
│   │       ├── rating-stars.blade.php
│   │       └── jarvis-widget.blade.php
│   ├── css/
│   │   ├── style.css (from WinCaseJobs)
│   │   ├── responsive.css
│   │   └── jarvis.css
│   └── js/
│       ├── theme.js
│       ├── search.js
│       ├── jarvis.js (voice recognition + TTS)
│       └── analytics.js
├── public/
│   ├── images/
│   ├── vendor/ (Bootstrap, jQuery, Slick, AOS, etc.)
│   └── index.php
├── routes/
│   ├── web.php
│   ├── api.php
│   ├── admin.php
│   └── telegram.php
├── tests/
├── .env.example
├── composer.json
├── package.json
├── webpack.mix.js (Laravel Mix, NOT Vite)
└── PROJECT.md
```

---

## API Endpoints (v1)

### Auth
- POST /api/v1/register
- POST /api/v1/login
- POST /api/v1/logout
- POST /api/v1/verify-email
- POST /api/v1/auth/telegram

### Jobs (Public)
- GET /api/v1/jobs (search, filter, paginate)
- GET /api/v1/jobs/{slug}
- GET /api/v1/jobs/categories
- POST /api/v1/jobs/{id}/view (track view)
- POST /api/v1/jobs/{id}/click (track click)

### Jobs (Employer)
- POST /api/v1/employer/jobs
- PUT /api/v1/employer/jobs/{id}
- DELETE /api/v1/employer/jobs/{id}
- GET /api/v1/employer/jobs/{id}/applications
- PUT /api/v1/employer/jobs/{id}/applications/{appId}

### Candidate
- GET /api/v1/candidate/profile
- PUT /api/v1/candidate/profile
- POST /api/v1/candidate/apply/{jobId}
- GET /api/v1/candidate/applications

### Reviews
- POST /api/v1/reviews/employer/{companyId}
- POST /api/v1/reviews/candidate/{profileId}
- GET /api/v1/reviews/employer/{companyId}
- GET /api/v1/reviews/candidate/{profileId}

### Payments
- POST /api/v1/payments/stripe/checkout
- POST /api/v1/payments/crypto/checkout
- POST /api/v1/payments/webhook/stripe
- POST /api/v1/payments/webhook/crypto

### Jarvis
- POST /api/v1/jarvis/command (voice/text command)
- GET /api/v1/jarvis/history

### Admin
- GET /api/v1/admin/dashboard
- GET /api/v1/admin/analytics
- CRUD /api/v1/admin/users
- CRUD /api/v1/admin/jobs
- CRUD /api/v1/admin/companies

### Telegram Webhook
- POST /api/v1/telegram/webhook

---

## Jarvis Master Agent - Architecture

### Overview
Jarvis is an AI-powered voice-controlled assistant integrated into the GURO JOBS admin/employer panel. It uses browser-native Web Speech API for voice recognition and TTS for responses, with Claude API for natural language understanding.

### Voice Pipeline
```
Microphone → Web Speech API (STT) → Text Command
    → Claude API (Intent Parsing) → Structured Command
    → CommandExecutor (Laravel Action) → Result
    → Claude API (Response Generation) → Natural Text
    → Web Speech API (TTS) → Speaker
```

### Jarvis Intents
| Intent | Example Commands |
|--------|-----------------|
| stats.today | "Show today's stats", "How many views today?" |
| stats.period | "Stats for last week", "Monthly report" |
| jobs.list | "Show active jobs", "List featured vacancies" |
| jobs.create | "Post new job for CMO", "Create vacancy" |
| jobs.update | "Pause job #123", "Close all expired jobs" |
| users.list | "Show new candidates", "List employers" |
| users.block | "Block user John", "Suspend employer X" |
| applications.list | "New applications today", "Pending reviews" |
| payments.status | "Revenue this month", "Pending payments" |
| search | "Find senior slot developers", "Search CMO candidates" |
| report.generate | "Generate monthly report", "Export analytics" |
| navigation | "Go to dashboard", "Open job #45" |

### Frontend Widget (jarvis-widget.blade.php)
- Floating button (bottom-right corner)
- Expandable panel with:
  - Waveform visualizer (listening state)
  - Chat-like command/response history
  - Push-to-talk button
  - Text input fallback
  - Status indicator (idle/listening/processing/speaking)
- Keyboard shortcut: Ctrl+J to toggle

### Security
- Jarvis available only to admin and employer roles
- All commands logged in jarvis_logs table
- Destructive actions require confirmation
- Rate limiting on API calls

---

## Platforms (4 штуки)

### 1. Website (gurojobs.com)
- Публичный сайт для соискателей и работодателей
- Bootstrap 5 + Blade (шаблон WinCaseJobs)
- SEO-оптимизированные страницы
- Поиск по ключевым словам, фильтры
- Регистрация/авторизация (email + Telegram)
- Публичные профили компаний
- Страницы вакансий с трекингом просмотров/кликов

### 2. Admin Panel (Desktop Web)
- Веб-админка на компьютере (admin.gurojobs.com)
- Bootstrap 5 + Blade (Herozi template, как у WinCase)
- Полное управление: вакансии, пользователи, компании, платежи
- Аналитика и отчёты
- Модерация контента и отзывов
- Jarvis AI Assistant (голосовое управление)
- Telegram bot management

### 3. Mobile App — Boss (Flutter)
- Для владельца/админа
- Дашборд с KPI в реальном времени
- Push-уведомления о новых регистрациях, платежах
- Быстрая модерация вакансий и пользователей
- Аналитика (графики, метрики)
- Jarvis голосовой ассистент (микрофон)
- Управление Telegram ботом
- iOS + Android

### 4. Mobile App — Client (Flutter)
- Для работодателей и кандидатов
- Работодатель: публикация вакансий, просмотр откликов, профиль компании
- Кандидат: поиск вакансий, подача заявок, профиль/резюме
- Push-уведомления
- Рейтинги и отзывы
- Оплата (карта, крипто, мобильный кошелёк)
- iOS + Android

### Mobile Directory Structure
```
mobile/
├── lib/
│   ├── main.dart
│   ├── app_config.dart (boss vs client mode)
│   ├── core/
│   │   ├── api_client.dart
│   │   ├── auth_service.dart
│   │   ├── push_notifications.dart
│   │   ├── theme.dart (WinCaseJobs colors #015EA7)
│   │   └── jarvis_voice.dart (Web Speech → native speech_to_text)
│   ├── models/
│   │   ├── user.dart
│   │   ├── job.dart
│   │   ├── company.dart
│   │   ├── application.dart
│   │   ├── review.dart
│   │   └── payment.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── jobs_provider.dart
│   │   ├── dashboard_provider.dart
│   │   ├── search_provider.dart
│   │   └── jarvis_provider.dart
│   ├── screens/
│   │   ├── shared/ (login, register, splash)
│   │   ├── boss/ (dashboard, analytics, moderation, jarvis)
│   │   └── client/
│   │       ├── employer/ (post job, applications, company profile)
│   │       └── candidate/ (search, apply, profile, reviews)
│   └── widgets/
│       ├── job_card.dart
│       ├── rating_stars.dart
│       ├── search_bar.dart
│       └── jarvis_fab.dart
├── assets/
│   ├── images/
│   └── fonts/
├── android/
├── ios/
├── pubspec.yaml
└── flutter_launcher_icons.yaml
```
