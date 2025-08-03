import 'package:flutter/material.dart';
class CosmicTheme {
  static ThemeData get lightTheme => ThemeData(useMaterial3: true, brightness: Brightness.light, colorScheme: const ColorScheme.light(primary: Color(0xFF3F51B5), secondary: Color(0xFF9C27B0), surface: Color(0xFFF8F9FF), onSurface: Color(0xFF1A1A2E)));
  static ThemeData get darkTheme => ThemeData(useMaterial3: true, brightness: Brightness.dark, colorScheme: const ColorScheme.dark(primary: Color(0xFF9FA8DA), secondary: Color(0xFFCE93D8), surface: Color(0xFF1A1A2E), onSurface: Color(0xFFFFFFFF)));
}