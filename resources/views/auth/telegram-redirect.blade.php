<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Sign in with Telegram — {{ config('app.name') }}</title>
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: #f6f8fa;
            color: #333;
        }
        h1 { font-size: 18px; margin: 0 0 8px; }
        p  { font-size: 13px; color: #666; margin: 0 0 24px; max-width: 360px; text-align: center; }
        .err {
            color: #b00020;
            background: #fde7ea;
            padding: 12px 16px;
            border-radius: 6px;
            max-width: 360px;
            text-align: center;
        }
    </style>
</head>
<body>
    <h1>Sign in with Telegram</h1>
    <p>Click the button below. We never see your password — Telegram signs the request cryptographically.</p>

    @if (empty($botUsername))
        <div class="err">
            Telegram bot is not configured.
            Set <code>TELEGRAM_BOT_USERNAME</code> in <code>.env</code> and run <code>php artisan config:clear</code>.
        </div>
    @else
        <script async
                src="https://telegram.org/js/telegram-widget.js?22"
                data-telegram-login="{{ $botUsername }}"
                data-size="large"
                data-userpic="true"
                data-request-access="write"
                data-auth-url="{{ $authUrl }}"></script>
    @endif
</body>
</html>
