import 'package:flutter/material.dart';
class CrystalTheme {
  static ThemeData get lightTheme => ThemeData(useMaterial3: true, brightness: Brightness.light, colorScheme: const ColorScheme.light(primary: Color(0xFF00BCD4), secondary: Color(0xFF26C6DA), surface: Color(0xFFF0FDFF), onSurface: Color(0xFF006064)));
  static ThemeData get darkTheme => ThemeData(useMaterial3: true, brightness: Brightness.dark, colorScheme: const ColorScheme.dark(primary: Color(0xFF84FFFF), secondary: Color(0xFFB2EBF2), surface: Color(0xFF006064), onSurface: Color(0xFFF0FDFF)));
}