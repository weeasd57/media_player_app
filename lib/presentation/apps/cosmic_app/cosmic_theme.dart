import 'package:flutter/material.dart';

class CosmicTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF3F51B5),
        secondary: Color(0xFF9C27B0),
        surface: Color(0xFFF8F9FF),
        surfaceContainer: Color(0xFFF0F1FF),
        surfaceContainerHighest: Color(0xFFE8E9FF),
        onSurface: Color(0xFF1A1A2E),
        outline: Color(0xFF757575),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF9FA8DA),
        secondary: Color(0xFFCE93D8),
        surface: Color(0xFF1A1A2E),
        surfaceContainer: Color(0xFF2A2A3E),
        surfaceContainerHighest: Color(0xFF3A3A4E),
        onSurface: Color(0xFFFFFFFF),
        outline: Color(0xFF757575),
      ),
    );
  }
}