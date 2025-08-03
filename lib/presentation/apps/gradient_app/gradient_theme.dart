import 'package:flutter/material.dart';

class GradientTheme {
  static const primaryColor = Color(0xFFFF6B6B);
  static const secondaryColor = Color(0xFF4ECDC4);
  static const accentColor = Color(0xFFFFE66D);

  static const primaryGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const secondaryGradient = LinearGradient(
    colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: Color(0xFFFFFFF5),
      onSurface: Color(0xFF2C3E50),
      surfaceContainerHighest: Color(0xFFF8F9FA),
      onSurfaceVariant: Color(0xFF34495E),
    ),
    cardTheme: CardThemeData(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        minimumSize: const Size(0, 48), // Add minimum size to prevent overflow
      ),
    ),
    buttonTheme: const ButtonThemeData(minWidth: 0, height: 48),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(48, 48)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: Color(0xFF1A1A2E),
      onSurface: Color(0xFFEEE3F0),
      surfaceContainerHighest: Color(0xFF16213E),
      onSurfaceVariant: Color(0xFFE94560),
    ),
    cardTheme: CardThemeData(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: const Color(0xFF0F3460),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        minimumSize: const Size(0, 48), // Add minimum size to prevent overflow
      ),
    ),
    buttonTheme: const ButtonThemeData(minWidth: 0, height: 48),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(48, 48)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
    ),
  );
}
