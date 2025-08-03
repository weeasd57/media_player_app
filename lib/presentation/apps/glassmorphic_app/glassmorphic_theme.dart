import 'package:flutter/material.dart';

class GlassmorphicTheme {
  static const primaryColor = Color(0xFF00D4FF);
  static const secondaryColor = Color(0xFF5B73FF);
  static const accentColor = Color(0xFFFF6B9D);
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: Color(0xFFF0F9FF),
      onSurface: Color(0xFF0F172A),
      surfaceVariant: Color(0xFFE0F2FE),
      onSurfaceVariant: Color(0xFF475569),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white.withOpacity(0.7),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        backgroundColor: Colors.white.withOpacity(0.2),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: Color(0xFF0F172A),
      onSurface: Color(0xFFF8FAFC),
      surfaceVariant: Color(0xFF1E293B),
      onSurfaceVariant: Color(0xFF94A3B8),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white.withOpacity(0.1),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        backgroundColor: Colors.white.withOpacity(0.1),
      ),
    ),
  );
}