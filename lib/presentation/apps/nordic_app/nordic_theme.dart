import 'package:flutter/material.dart';

class NordicTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF37474F),
        secondary: Color(0xFF546E7A),
        surface: Color(0xFFFAFAFA),
        surfaceContainer: Color(0xFFF0F0F0),
        surfaceContainerHighest: Color(0xFFE5E5E5),
        onSurface: Color(0xFF263238),
        outline: Color(0xFF757575),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF90A4AE),
        secondary: Color(0xFFB0BEC5),
        surface: Color(0xFF263238),
        surfaceContainer: Color(0xFF37474F),
        surfaceContainerHighest: Color(0xFF455A64),
        onSurface: Color(0xFFFAFAFA),
        outline: Color(0xFF757575),
      ),
    );
  }
}