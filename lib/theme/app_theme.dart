

import 'package:flutter/material.dart';

class AppTheme {
  static const Color seedColor = Color(0xFF00695C);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
        primary: const Color(0xFF006A60),
        primaryContainer: const Color(0xFF9EF2E4),
        secondaryContainer: const Color(0xFFCCE8E2),
        tertiary: const Color(0xFF456179),
        error: const Color(0xFFBA1A1A),
        errorContainer: const 

Color(0xFFFFDAD6),
        surface: const Color(0xFFF4FBF9),
        surfaceContainer: const Color(0xFFE9EFED),
        outline: const Color(0xFF6F7977),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        color: const Color(0xFFE9EFED),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: 

InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
        primary: const Color(0xFF53DBC9),
        primaryContainer: const Color(0xFF005047),
        secondaryContainer: const Color(0xFF314B47),
        tertiary: const Color(0xFFADCAE6),
        error: const Color(0xFFFFB4AB),

        errorContainer: const Color(0xFF93000A),
        surface: const Color(0xFF0E1514),
        surfaceContainer: const Color(0xFF1A2120),
        outline: const Color(0xFF899390),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        color: const Color(0xFF1A2120),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
    );
  }
}
