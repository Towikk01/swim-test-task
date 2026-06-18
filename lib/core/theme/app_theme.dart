import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF0B1622);
  static const surface = Color(0xFF15212E);
  static const surfaceVariant = Color(0xFF1E2C3A);
  static const accent = Color(0xFF2DD4BF);
  static const accentMuted = Color(0xFF1F8A7E);
  static const textPrimary = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFF94A3B8);
  static const error = Color(0xFFF87171);
}

abstract final class AppTheme {
  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      surface: AppColors.background,
      primary: AppColors.accent,
      secondary: AppColors.accent,
      error: AppColors.error,
      onPrimary: AppColors.background,
      onSurface: AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AppColors.textPrimary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
