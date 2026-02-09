import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF2E7D32); // Forest Green
  static const Color secondaryGreen = Color(0xFF4CAF50); // Standard Green
  static const Color backgroundBeige = Color(0xFFF5F5DC); // Beige
  static const Color surfaceBeige = Color(
    0xFFFFF8E1,
  ); // Lighter Beige for cards

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: secondaryGreen,
        surface: surfaceBeige,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.brown.shade900,
      ),
      scaffoldBackgroundColor: backgroundBeige,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryGreen.withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryGreen.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.brown.shade700),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: Colors.brown.shade900,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: Colors.brown.shade900,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: Colors.brown.shade800),
        bodyMedium: TextStyle(color: Colors.brown.shade800),
      ),
    );
  }
}
