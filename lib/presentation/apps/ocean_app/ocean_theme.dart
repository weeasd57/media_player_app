import 'package:flutter/material.dart';

class OceanTheme {
  static const primaryColor = Color(0xFF006A6B);
  static const secondaryColor = Color(0xFF0891B2);
  static const accentColor = Color(0xFF06B6D4);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: Color(0xFFF0FDFF),
      onSurface: Color(0xFF164E63),
      surfaceContainerHighest: Color(0xFFE0F7FA),
      onSurfaceVariant: Color(0xFF0E7490),
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 48), // Add minimum size to prevent overflow
      ),
    ),
    buttonTheme: const ButtonThemeData(minWidth: 0, height: 48),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(48, 48)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: WidgetStateProperty.all(EdgeInsets.zero),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: accentColor,
      secondary: secondaryColor,
      tertiary: primaryColor,
      surface: Color(0xFF0C1821),
      onSurface: Color(0xFF7DD3FC),
      surfaceContainerHighest: Color(0xFF164E63),
      onSurfaceVariant: Color(0xFFBAE6FD),
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFF164E63),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: accentColor,
        foregroundColor: const Color(0xFF0C1821),
        minimumSize: const Size(0, 48), // Add minimum size to prevent overflow
      ),
    ),
    buttonTheme: const ButtonThemeData(minWidth: 0, height: 48),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(48, 48)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: WidgetStateProperty.all(EdgeInsets.zero),
      ),
    ),
  );
}
