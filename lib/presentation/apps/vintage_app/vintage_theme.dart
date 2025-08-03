import 'package:flutter/material.dart';

class VintageTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF8D6E63),
        secondary: Color(0xFFA1887F),
        surface: Color(0xFFFFF8E1),
        surfaceContainer: Color(0xFFF3E5AB),
        surfaceContainerHighest: Color(0xFFEEDCAB),
        onSurface: Color(0xFF3E2723),
        outline: Color(0xFF757575),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFBCAAA4),
        secondary: Color(0xFFD7CCC8),
        surface: Color(0xFF3E2723),
        surfaceContainer: Color(0xFF4E342E),
        surfaceContainerHighest: Color(0xFF5D4037),
        onSurface: Color(0xFFFFF8E1),
        outline: Color(0xFF757575),
      ),
    );
  }
}