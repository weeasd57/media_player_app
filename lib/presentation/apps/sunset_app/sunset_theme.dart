import 'package:flutter/material.dart';

class SunsetTheme {
  static const primaryColor = Color(0xFFFF6B35);
  static const secondaryColor = Color(0xFFF7931E);
  static const accentColor = Color(0xFFFFD23F);

  static const sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFF7931E), Color(0xFFFFD23F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: Color(0xFFFFFBF0),
      onSurface: Color(0xFF8B4000),
      surfaceContainerHighest: Color(0xFFFFF8E1),
      onSurfaceVariant: Color(0xFFBF6000),
    ),
    cardTheme: CardThemeData(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
      surface: Color(0xFF1A0E00),
      onSurface: Color(0xFFFFD23F),
      surfaceContainerHighest: Color(0xFF2D1B00),
      onSurfaceVariant: Color(0xFFF7931E),
    ),
    cardTheme: CardThemeData(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF2D1B00),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
