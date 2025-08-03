import 'package:flutter/material.dart';

class CrystalTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF00BCD4),
        secondary: Color(0xFF26C6DA),
        surface: Color(0xFFF0FDFF),
        surfaceContainer: Color(0xFFE0F7FA),
        surfaceContainerHighest: Color(0xFFB2EBF2),
        onSurface: Color(0xFF006064),
        outline: Color(0xFF757575),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF84FFFF),
        secondary: Color(0xFFB2EBF2),
        surface: Color(0xFF006064),
        surfaceContainer: Color(0xFF00838F),
        surfaceContainerHighest: Color(0xFF0097A7),
        onSurface: Color(0xFFF0FDFF),
        outline: Color(0xFF757575),
      ),
    );
  }
}