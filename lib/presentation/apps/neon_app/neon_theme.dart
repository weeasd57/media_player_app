import 'package:flutter/material.dart';

class NeonTheme {
  static const Color _neonPink = Color(0xFFFF0080);
  static const Color _neonCyan = Color(0xFF00FFFF);
  // static const Color _neonPurple = Color(0xFF8000FF);
  // static const Color _neonGreen = Color(0xFF00FF00);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _neonPink,
        secondary: _neonCyan,
        surface: Color(0xFFFAFAFA),
        surfaceContainer: Color(0xFFF0F0F0),
        surfaceContainerHighest: Color(0xFFE0E0E0),
        onSurface: Color(0xFF1A1A1A),
        outline: Color(0xFF757575),
      ),
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFAFAFA),
        foregroundColor: Color(0xFF1A1A1A),
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFFFFFFFF),
        elevation: 4,
        shadowColor: _neonPink.withValues(
          alpha: ((_neonPink.a * 0.2 * 255.0).round() & 0xff) as double?,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: _neonPink.withValues(
              alpha: ((_neonPink.a * 0.3 * 255.0).round() & 0xff) as double?,
            ),
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _neonPink,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: _neonPink.withValues(
            alpha: ((_neonPink.a * 0.5 * 255.0).round() & 0xff) as double?,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _neonPink,
        secondary: _neonCyan,
        surface: Color(0xFF0A0A0A),
        surfaceContainer: Color(0xFF1A1A1A),
        surfaceContainerHighest: Color(0xFF2A2A2A),
        onSurface: Color(0xFFFFFFFF),
        outline: Color(0xFF757575),
      ),
      scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0A0A0A),
        foregroundColor: Color(0xFFFFFFFF),
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1A1A1A),
        elevation: 8,
        shadowColor: _neonPink.withValues(
          alpha: ((_neonPink.a * 0.5 * 255.0).round() & 0xff) as double?,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _neonPink, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _neonPink,
          foregroundColor: Colors.white,
          elevation: 12,
          shadowColor: _neonPink.withValues(
            alpha: ((_neonPink.a * 0.8 * 255.0).round() & 0xff) as double?,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
