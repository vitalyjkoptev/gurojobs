import 'package:flutter/material.dart';

/// GURO JOBS Theme — Same colors as WinCaseJobs
class GuroJobsTheme {
  // Brand colors (from WinCaseJobs)
  static const Color primary = Color(0xFF015EA7);
  static const Color primaryDark = Color(0xFF014A85);
  static const Color primaryLight = Color(0xFF0277BD);
  static const Color accent = Color(0xFF00BCD4);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFFF5722);
  static const Color info = Color(0xFF2196F3);

  // Light neutrals
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  static const Color divider = Color(0xFFE0E0E0);

  // Dark neutrals
  static const Color darkBackground = Color(0xFF0F0F17);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF1E1E32);
  static const Color darkTextPrimary = Color(0xFFE8E8EC);
  static const Color darkTextSecondary = Color(0xFF9A9AAE);
  static const Color darkTextHint = Color(0xFF5C5C6E);
  static const Color darkDivider = Color(0xFF2A2A3E);
  static const Color darkInputFill = Color(0xFF1E1E32);

  // Jarvis colors
  static const Color jarvisBg = Color(0xFF1A1A2E);
  static const Color jarvisAccent = Color(0xFF015EA7);

  // Experience level colors
  static const Map<String, Color> experienceLevelColors = {
    'c-level': Color(0xFFD4AF37),
    'head': Color(0xFF9C27B0),
    'senior': Color(0xFF015EA7),
    'middle': Color(0xFF4CAF50),
    'junior': Color(0xFF03A9F4),
  };

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        secondary: accent,
        surface: surface,
        error: error,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: surface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: divider)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: divider)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: primary, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: textHint,
        type: BottomNavigationBarType.fixed,
      ),
      dividerColor: divider,
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        primary: primaryLight,
        secondary: accent,
        surface: darkSurface,
        error: error,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF12122A),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: darkCard,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkInputFill,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: darkDivider)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: darkDivider)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: primaryLight, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF12122A),
        selectedItemColor: primaryLight,
        unselectedItemColor: darkTextHint,
        type: BottomNavigationBarType.fixed,
      ),
      dividerColor: darkDivider,
      dialogTheme: DialogThemeData(
        backgroundColor: darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Color(0xFF1A1A2E)),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        collapsedIconColor: darkTextHint,
        iconColor: primaryLight,
      ),
    );
  }
}

/// Theme-aware color extension — use instead of hardcoded Colors.white / GuroJobsTheme.textPrimary etc.
extension GuroThemeX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // Surfaces
  Color get cardBg => isDark ? GuroJobsTheme.darkCard : Colors.white;
  Color get surfaceBg => isDark ? GuroJobsTheme.darkSurface : GuroJobsTheme.background;
  Color get inputFill => isDark ? GuroJobsTheme.darkInputFill : Colors.white;

  // Text
  Color get textPrimaryC => isDark ? GuroJobsTheme.darkTextPrimary : GuroJobsTheme.textPrimary;
  Color get textSecondaryC => isDark ? GuroJobsTheme.darkTextSecondary : GuroJobsTheme.textSecondary;
  Color get textHintC => isDark ? GuroJobsTheme.darkTextHint : GuroJobsTheme.textHint;

  // Border/divider
  Color get dividerC => isDark ? GuroJobsTheme.darkDivider : GuroJobsTheme.divider;

  // Shadow
  Color get shadowC => isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.04);
  Color get shadowMedium => isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.06);
}
