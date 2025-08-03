import 'package:flutter/material.dart';
class SynthwaveTheme {
  static ThemeData get lightTheme => ThemeData(useMaterial3: true, brightness: Brightness.light, colorScheme: const ColorScheme.light(primary: Color(0xFFFF6EC7), secondary: Color(0xFF00D4FF), surface: Color(0xFFFAF0FF), onSurface: Color(0xFF1A1A2E)));
  static ThemeData get darkTheme => ThemeData(useMaterial3: true, brightness: Brightness.dark, colorScheme: const ColorScheme.dark(primary: Color(0xFFFF6EC7), secondary: Color(0xFF00D4FF), surface: Color(0xFF1A1A2E), onSurface: Color(0xFFFFFFFF)));
}