import 'package:flutter/material.dart';
class NordicTheme {
  static ThemeData get lightTheme => ThemeData(useMaterial3: true, brightness: Brightness.light, colorScheme: const ColorScheme.light(primary: Color(0xFF37474F), secondary: Color(0xFF546E7A), surface: Color(0xFFFAFAFA), onSurface: Color(0xFF263238)));
  static ThemeData get darkTheme => ThemeData(useMaterial3: true, brightness: Brightness.dark, colorScheme: const ColorScheme.dark(primary: Color(0xFF90A4AE), secondary: Color(0xFFB0BEC5), surface: Color(0xFF263238), onSurface: Color(0xFFFAFAFA)));
}