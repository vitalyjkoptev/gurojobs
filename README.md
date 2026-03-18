# GURO JOBS

**iGaming Job Portal** — Laravel 12 + Flutter

## Stack

- **Backend:** Laravel 12, PHP 8.4, MySQL, Redis, Sanctum
- **Frontend:** Blade + Bootstrap 5 (Herozi template)
- **Mobile:** Flutter 3.3+ (Android)
- **Server:** AlmaLinux 9, cPanel, Hostinger KVM

## Structure

```
├── app/                  # Laravel backend
├── resources/views/      # Blade templates (admin, public, auth)
├── routes/               # Web + API routes
├── mobile/               # Flutter mobile app
│   ├── lib/screens/      # Candidate, Employer, Admin screens
│   ├── lib/providers/    # State management
│   └── lib/services/     # API service
├── database/             # Migrations + seeders
├── public/               # CSS, JS, images
└── config/               # App config
```

## Roles

| Role | Web | Mobile | API |
|------|-----|--------|-----|
| Admin | `/admin/login` → `/admin` | Flutter admin dashboard | `/api/v1/*` |
| Employer | `/login` → `/dashboard` | Flutter employer dashboard | `/api/v1/*` |
| Candidate | `/login` → `/dashboard` | Flutter candidate dashboard | `/api/v1/*` |

## Features

- Job search & filtering (8 iGaming categories)
- CV/Resume builder
- Contact paywall (Telegram, LinkedIn, DM — admin sets prices)
- Application tracking
- Employer job management
- Admin panel (users, jobs, companies, payments, analytics)
- Jarvis AI assistant
- 3 languages (EN, RU, UK)
- WebAuthn passkeys
- Stripe + crypto payments

## URLs

- **Site:** https://gurojobs.com
- **Admin:** https://gurojobs.com/admin/login
- **App download:** https://gurojobs.com/app
- **API:** https://gurojobs.com/api/v1

## Setup

```bash
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan db:seed
```

Flutter:
```bash
cd mobile
flutter pub get
flutter run
```
