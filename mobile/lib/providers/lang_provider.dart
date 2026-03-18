import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/localization.dart';

class LangProvider extends ChangeNotifier {
  final SharedPreferences prefs;

  static const _supportedLangs = ['en', 'ru', 'uk'];

  LangProvider(this.prefs) {
    final saved = prefs.getString('app_lang');
    if (saved != null && _supportedLangs.contains(saved)) {
      AppStrings.setLang(saved);
    } else {
      // Default to English — user can change in profile
      AppStrings.setLang('en');
      prefs.setString('app_lang', 'en');
    }
  }

  String get currentLang => AppStrings.currentLang;

  Future<void> setLang(String lang) async {
    AppStrings.setLang(lang);
    await prefs.setString('app_lang', lang);
    notifyListeners();
  }

  String _detectSystemLang() {
    final locale = PlatformDispatcher.instance.locale;
    final code = locale.languageCode;
    if (_supportedLangs.contains(code)) return code;
    return 'en';
  }
}
