import 'package:flutter/material.dart';

abstract final class AppColors {
  static const ink = Color(0xFF111318);
  static const charcoal = Color(0xFF191C22);
  static const slate = Color(0xFF9BA2AF);
  static const mist = Color(0xFFF5F3EF);
  static const paper = Color(0xFFFFFFFF);
  static const coral = Color(0xFFFF806C);
  static const coralSoft = Color(0xFFFFB09E);
  static const mint = Color(0xFF9BD7C4);
  static const mintDeep = Color(0xFF267A66);
  static const line = Color(0xFF2D323B);
}

abstract final class AppTheme {
  static ThemeData get light => _theme(Brightness.light);

  static ThemeData get dark => _theme(Brightness.dark);

  static ThemeData get black => _theme(Brightness.dark, true);

  static ThemeData get white => _theme(Brightness.light, false);

  static ThemeData _theme(Brightness brightness, [bool deepBlack = false]) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.coral,
      brightness: brightness,
      surface: isDark ? AppColors.charcoal : AppColors.paper,
      primary: isDark ? AppColors.coral : AppColors.ink,
    );

    return ThemeData(
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? (deepBlack ? Colors.black : AppColors.ink) : AppColors.mist,
      fontFamily: 'Avenir',
      useMaterial3: true,
      appBarTheme: AppBarTheme(centerTitle: false, elevation: 0, backgroundColor: isDark ? AppColors.ink : AppColors.mist),
      cardTheme: CardThemeData(
        color: isDark ? (deepBlack ? const Color(0xFF0B0B0D) : AppColors.charcoal) : AppColors.paper,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isDark ? AppColors.line : const Color(0xFFE5E2DC))),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.charcoal : AppColors.paper,
        indicatorColor: isDark ? AppColors.coral.withValues(alpha: .18) : AppColors.ink.withValues(alpha: .08),
        labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.ink)),
      ),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: isDark ? AppColors.coral : AppColors.ink, foregroundColor: isDark ? AppColors.ink : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15))),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF22262E) : AppColors.paper,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      ),
      textTheme: TextTheme(
        displaySmall: TextStyle(
          color: isDark ? Colors.white : AppColors.ink,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          height: 1.1,
        ),
        headlineSmall: TextStyle(
          color: isDark ? Colors.white : AppColors.ink,
          fontSize: 23,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: isDark ? Colors.white : AppColors.ink,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(
          color: isDark ? const Color(0xFFB8C6C2) : AppColors.slate,
          fontSize: 14,
          height: 1.45,
        ),
      ),
    );
  }
}