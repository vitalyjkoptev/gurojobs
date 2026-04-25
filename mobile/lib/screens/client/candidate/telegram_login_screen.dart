import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/api_service.dart';
import 'dashboard_screen.dart';
import '../../employer/employer_dashboard.dart';

/// Открывает /auth/telegram/redirect в WebView, ловит редирект Telegram'а на
/// /auth/telegram/callback?... — забирает query-параметры (id, hash, auth_date,
/// first_name, last_name, username, photo_url) и шлёт их в API.
class TelegramLoginScreen extends StatefulWidget {
  const TelegramLoginScreen({super.key});

  @override
  State<TelegramLoginScreen> createState() => _TelegramLoginScreenState();
}

class _TelegramLoginScreenState extends State<TelegramLoginScreen> {
  late final WebViewController _controller;
  bool _busy = false;

  static const _payloadKeys = {
    'id', 'first_name', 'last_name', 'username', 'photo_url', 'auth_date', 'hash',
  };

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: _handleNavigation,
      ))
      ..loadRequest(Uri.parse(ApiService.telegramRedirectUrl));
  }

  Future<NavigationDecision> _handleNavigation(NavigationRequest request) async {
    final uri = Uri.tryParse(request.url);
    if (uri == null) return NavigationDecision.navigate;

    final isCallback = uri.path.endsWith('/auth/telegram/callback');
    if (!isCallback || uri.queryParameters['hash'] == null) {
      return NavigationDecision.navigate;
    }

    if (_busy) return NavigationDecision.prevent;
    _busy = true;

    final payload = <String, String>{
      for (final entry in uri.queryParameters.entries)
        if (_payloadKeys.contains(entry.key)) entry.key: entry.value,
    };

    final auth = context.read<AuthProvider>();
    final ok = await auth.loginWithTelegram(payload);

    if (!mounted) return NavigationDecision.prevent;

    if (ok) {
      final next = auth.userRole == 'employer'
          ? const EmployerDashboardScreen()
          : const DashboardScreen();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => next));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Telegram login failed'),
          backgroundColor: GuroJobsTheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    }

    return NavigationDecision.prevent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in with Telegram'),
        backgroundColor: Colors.white,
        foregroundColor: GuroJobsTheme.textPrimary,
        elevation: 0,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
