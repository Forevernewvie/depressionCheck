import 'package:flutter/material.dart';
import 'package:vibemental_app/core/theme/app_semantic_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    const background = Color(0xFFF8FAFC);
    const surface = Color(0xFFFFFFFF);
    const textPrimary = Color(0xFF0F172A);
    const textSecondary = Color(0xFF334155);
    const border = Color(0xFFCBD5E1);

    final colorScheme = const ColorScheme.light(
      primary: Color(0xFF1D4ED8),
      secondary: Color(0xFF334155),
      error: Color(0xFFB91C1C),
      surface: surface,
      onPrimary: Colors.white,
      onSurface: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      cardTheme: const CardThemeData(
        color: surface,
        margin: EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: border),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: border),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textPrimary, height: 1.4),
        bodyMedium: TextStyle(fontSize: 14, color: textSecondary, height: 1.5),
      ),
      extensions: const [
        AppSemanticColors(
          success: Color(0xFF166534),
          warning: Color(0xFFB45309),
          danger: Color(0xFFB91C1C),
          emergencyBackground: Color(0xFF7F1D1D),
          emergencyText: Color(0xFFFEF2F2),
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    const background = Color(0xFF020617);
    const surface = Color(0xFF0F172A);
    const textPrimary = Color(0xFFF8FAFC);
    const textSecondary = Color(0xFFCBD5E1);
    const border = Color(0xFF334155);

    final colorScheme = const ColorScheme.dark(
      primary: Color(0xFF2563EB),
      secondary: Color(0xFFCBD5E1),
      error: Color(0xFFF87171),
      surface: surface,
      onPrimary: Colors.white,
      onSurface: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      cardTheme: const CardThemeData(
        color: surface,
        margin: EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: border),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: border),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textPrimary, height: 1.4),
        bodyMedium: TextStyle(fontSize: 14, color: textSecondary, height: 1.5),
      ),
      extensions: const [
        AppSemanticColors(
          success: Color(0xFF34D399),
          warning: Color(0xFFFBBF24),
          danger: Color(0xFFF87171),
          emergencyBackground: Color(0xFF7F1D1D),
          emergencyText: Color(0xFFFEF2F2),
        ),
      ],
    );
  }
}
