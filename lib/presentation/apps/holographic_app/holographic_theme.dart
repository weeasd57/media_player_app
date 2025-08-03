import 'package:flutter/material.dart';
class HolographicTheme {
  static ThemeData get lightTheme => ThemeData(useMaterial3: true, brightness: Brightness.light, colorScheme: const ColorScheme.light(primary: Color(0xFF9C27B0), secondary: Color(0xFF673AB7), surface: Color(0xFFFAFAFA), onSurface: Color(0xFF1A1A1A)));
  static ThemeData get darkTheme => ThemeData(useMaterial3: true, brightness: Brightness.dark, colorScheme: const ColorScheme.dark(primary: Color(0xFFE1BEE7), secondary: Color(0xFFD1C4E9), surface: Color(0xFF1A1A1A), onSurface: Color(0xFFFFFFFF)));
}