import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  late ThemeMode _mode;

  ThemeProvider(this.prefs) {
    final saved = prefs.getString('theme_mode') ?? 'light';
    switch (saved) {
      case 'dark':
        _mode = ThemeMode.dark;
        break;
      case 'system':
        _mode = ThemeMode.system;
        break;
      default:
        _mode = ThemeMode.light;
    }
  }

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  Future<void> setMode(ThemeMode mode) async {
    _mode = mode;
    final key = mode == ThemeMode.dark ? 'dark' : (mode == ThemeMode.system ? 'system' : 'light');
    await prefs.setString('theme_mode', key);
    notifyListeners();
  }

  Future<void> toggle() async {
    await setMode(_mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}
