import 'package:flutter/material.dart';

class SynthwaveTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFFF6EC7),
        secondary: Color(0xFF00D4FF),
        surface: Color(0xFFFAF0FF),
        surfaceContainer: Color(0xFFF0E6FF),
        surfaceContainerHighest: Color(0xFFE6DCFF),
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
        primary: Color(0xFFFF6EC7),
        secondary: Color(0xFF00D4FF),
        surface: Color(0xFF1A1A2E),
        surfaceContainer: Color(0xFF2A2A3E),
        surfaceContainerHighest: Color(0xFF3A3A4E),
        onSurface: Color(0xFFFFFFFF),
        outline: Color(0xFF757575),
      ),
    );
  }
}