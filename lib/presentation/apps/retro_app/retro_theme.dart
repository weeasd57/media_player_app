import 'package:flutter/material.dart';

class RetroTheme {
  static const primaryColor = Color(0xFFE74C3C);
  static const secondaryColor = Color(0xFFF39C12);
  static const accentColor = Color(0xFF8E44AD);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: Color(0xFFFDF6E3),
      onSurface: Color(0xFF8B4513),
      surfaceContainerHighest: Color(0xFFF4ECD8),
      onSurfaceVariant: Color(0xFFD2691E),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF8B4513), width: 3),
      ),
      color: const Color(0xFFFFFAF0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 6,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: Color(0xFF2C1810),
      onSurface: Color(0xFFDEB887),
      surfaceContainerHighest: Color(0xFF3D2817),
      onSurfaceVariant: Color(0xFFD2B48C),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFDEB887), width: 3),
      ),
      color: const Color(0xFF3D2817),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 6,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
