/// GURO JOBS App Configuration
/// Determines whether the app runs in Boss or Client mode.
///
/// Build flavors:
///   flutter run --dart-define=APP_MODE=boss
///   flutter run --dart-define=APP_MODE=client

enum AppMode { boss, client }

class AppConfig {
  static const String appName = 'GURO JOBS';
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://gurojobs.com',
  );

  static const AppMode mode = AppMode.values.byName(
    String.fromEnvironment('APP_MODE', defaultValue: 'client'),
  );

  static bool get isBossMode => mode == AppMode.boss;
  static bool get isClientMode => mode == AppMode.client;

  static String get appTitle => isBossMode ? 'GURO JOBS Boss' : 'GURO JOBS';

  /// Features available per mode
  static bool get hasJarvis => isBossMode;
  static bool get hasAnalytics => isBossMode;
  static bool get hasModeration => isBossMode;
  static bool get hasJobPosting => true; // Both modes (employer in client)
  static bool get hasJobSearch => isClientMode;
  static bool get hasPayments => true;
}
