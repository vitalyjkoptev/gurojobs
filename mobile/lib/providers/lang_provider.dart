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
      // First launch — detect from device language
      final systemLang = _detectSystemLang();
      AppStrings.setLang(systemLang);
      prefs.setString('app_lang', systemLang);
    }
  }

  String get currentLang => AppStrings.currentLang;

  Future<void> setLang(String lang) async {
    if (lang == AppStrings.currentLang) return;
    AppStrings.setLang(lang);
    notifyListeners();
    await prefs.setString('app_lang', lang);
  }

  String _detectSystemLang() {
    final locale = PlatformDispatcher.instance.locale;
    final code = locale.languageCode;
    if (_supportedLangs.contains(code)) return code;
    return 'en';
  }
}
