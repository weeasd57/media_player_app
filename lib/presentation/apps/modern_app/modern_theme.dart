import 'package:flutter/material.dart';

class ModernTheme {
  static const primaryColor = Color(0xFF6366F1);
  static const secondaryColor = Color(0xFF8B5CF6);
  static const accentColor = Color(0xFF06B6D4);
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: Color(0xFFFAFAFA),
      onSurface: Color(0xFF1F2937),
      surfaceVariant: Color(0xFFF3F4F6),
      onSurfaceVariant: Color(0xFF6B7280),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: Color(0xFF111827),
      onSurface: Color(0xFFF9FAFB),
      surfaceVariant: Color(0xFF1F2937),
      onSurfaceVariant: Color(0xFF9CA3AF),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color(0xFF1F2937),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}