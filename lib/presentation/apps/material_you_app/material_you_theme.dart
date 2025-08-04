import 'package:flutter/material.dart';

class MaterialYouTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF6750A4),
        secondary: Color(0xFF625B71),
        surface: Color(0xFFFFFBFE),
        surfaceContainer: Color(0xFFF3EDF7),
        surfaceContainerHighest: Color(0xFFE6E0E9),
        onSurface: Color(0xFF1C1B1F),
        outline: Color(0xFF79747E),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFD0BCFF),
        secondary: Color(0xFFCCC2DC),
        surface: Color(0xFF141218),
        surfaceContainer: Color(0xFF211F26),
        surfaceContainerHighest: Color(0xFF2B2930),
        onSurface: Color(0xFFE6E0E9),
        outline: Color(0xFF938F99),
      ),
    );
  }
}