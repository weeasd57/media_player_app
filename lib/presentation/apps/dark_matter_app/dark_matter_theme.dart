import 'package:flutter/material.dart';

class DarkMatterTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF1A1A1A),
        secondary: Color(0xFF333333),
        surface: Color(0xFFF5F5F5),
        onSurface: Color(0xFF1A1A1A),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF666666),
        secondary: Color(0xFF888888),
        surface: Color(0xFF0A0A0A),
        onSurface: Color(0xFFFFFFFF),
      ),
    );
  }
}