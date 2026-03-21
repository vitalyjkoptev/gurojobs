import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/jarvis_provider.dart';
import 'providers/contact_credits_provider.dart';
import 'providers/lang_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/client/candidate/splash_screen.dart';
import 'screens/client/candidate/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(prefs)),
        ChangeNotifierProvider(create: (_) => ContactCreditsProvider(prefs)),
        ChangeNotifierProvider(create: (_) => JarvisProvider()),
        ChangeNotifierProvider(create: (_) => LangProvider(prefs)),
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
      ],
      child: const GuroJobsApp(),
    ),
  );
}

class GuroJobsApp extends StatelessWidget {
  const GuroJobsApp({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<LangProvider>();
    final themeProv = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'GURO JOBS',
      debugShowCheckedModeBanner: false,
      theme: GuroJobsTheme.lightTheme,
      darkTheme: GuroJobsTheme.darkTheme,
      themeMode: themeProv.mode,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/admin': (_) => const RegisterScreen(initialLogin: true, forceRole: 'admin'),
      },
    );
  }
}
