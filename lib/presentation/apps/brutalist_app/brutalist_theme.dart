import 'package:flutter/material.dart';
class BrutalistTheme {
  static ThemeData get lightTheme => ThemeData(useMaterial3: true, brightness: Brightness.light, colorScheme: const ColorScheme.light(primary: Color(0xFF424242), secondary: Color(0xFF616161), surface: Color(0xFFFFFFFF), onSurface: Color(0xFF000000)));
  static ThemeData get darkTheme => ThemeData(useMaterial3: true, brightness: Brightness.dark, colorScheme: const ColorScheme.dark(primary: Color(0xFF9E9E9E), secondary: Color(0xFFBDBDBD), surface: Color(0xFF212121), onSurface: Color(0xFFFFFFFF)));
}