import 'package:flutter/material.dart';

class BrutalistTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF424242),
        secondary: Color(0xFF616161),
        surface: Color(0xFFFFFFFF),
        surfaceContainer: Color(0xFFF5F5F5),
        surfaceContainerHighest: Color(0xFFE0E0E0),
        onSurface: Color(0xFF000000),
        outline: Color(0xFF757575),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF9E9E9E),
        secondary: Color(0xFFBDBDBD),
        surface: Color(0xFF212121),
        surfaceContainer: Color(0xFF2E2E2E),
        surfaceContainerHighest: Color(0xFF3A3A3A),
        onSurface: Color(0xFFFFFFFF),
        outline: Color(0xFF757575),
      ),
    );
  }
}