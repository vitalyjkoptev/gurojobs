<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Signed in</title>
</head>
<body>
<script>
    (function () {
        try {
            localStorage.setItem('auth_token', @json($token));
        } catch (e) { /* ignore */ }

        var redirect = @json($redirect);

        if (window.opener && !window.opener.closed) {
            try {
                window.opener.postMessage(
                    { type: 'telegram_auth_success', redirect: redirect },
                    window.location.origin
                );
                window.close();
                return;
            } catch (e) { /* fall through */ }
        }

        window.location.replace(redirect);
    })();
</script>
<noscript>
    <p>Signed in. <a href="{{ $redirect }}">Continue</a></p>
</noscript>
</body>
</html>
