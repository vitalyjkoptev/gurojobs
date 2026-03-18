# Contributing to GURO JOBS

## How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit changes (`git commit -m 'Add my feature'`)
4. Push to branch (`git push origin feature/my-feature`)
5. Open a Pull Request

## Development Setup

```bash
# Backend
composer install
cp .env.example.gurojobs .env
php artisan key:generate
php artisan migrate
php artisan db:seed

# Mobile
cd mobile
flutter pub get
flutter run
```

## Code Standards

- PHP: PSR-12
- Dart: Flutter style guide
- Commits: conventional commits (feat:, fix:, docs:)

## License

By contributing, you agree to the Business Source License 1.1.
