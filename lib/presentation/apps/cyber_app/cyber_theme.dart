import 'package:flutter/material.dart';

class CyberTheme {
  static const primaryColor = Color(0xFF00FF9F);
  static const secondaryColor = Color(0xFFFF0080);
  static const accentColor = Color(0xFF00D7FF);
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: Color(0xFFF0F0F3),
      onSurface: Color(0xFF1A1A1A),
      surfaceVariant: Color(0xFFE8E8E8),
      onSurfaceVariant: Color(0xFF2D2D30),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: primaryColor, width: 2),
      ),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: primaryColor, width: 2),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: primaryColor,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: Color(0xFF0D1117),
      onSurface: Color(0xFF00FF9F),
      surfaceVariant: Color(0xFF161B22),
      onSurfaceVariant: Color(0xFF00FF9F),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: primaryColor, width: 2),
      ),
      color: const Color(0xFF0D1117),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: primaryColor, width: 2),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: primaryColor,
      ),
    ),
  );
}