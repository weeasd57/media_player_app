import 'package:flutter/material.dart';
class VintageTheme {
  static ThemeData get lightTheme => ThemeData(useMaterial3: true, brightness: Brightness.light, colorScheme: const ColorScheme.light(primary: Color(0xFF8D6E63), secondary: Color(0xFFA1887F), surface: Color(0xFFFFF8E1), onSurface: Color(0xFF3E2723)));
  static ThemeData get darkTheme => ThemeData(useMaterial3: true, brightness: Brightness.dark, colorScheme: const ColorScheme.dark(primary: Color(0xFFBCAAA4), secondary: Color(0xFFD7CCC8), surface: Color(0xFF3E2723), onSurface: Color(0xFFFFF8E1)));
}