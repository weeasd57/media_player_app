import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // Removed unused import

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark; // New: isDarkMode getter

  ThemeData get currentTheme =>
      _themeMode == ThemeMode.dark ? _buildDarkTheme() : _buildLightTheme();

  // New: Getters for custom colors/properties from _CustomColors extension
  Color get primaryBackgroundColor =>
      currentTheme.extension<_CustomColors>()!.primaryBackgroundColor;
  Color get secondaryBackgroundColor =>
      currentTheme.extension<_CustomColors>()!.secondaryBackgroundColor;
  Color get cardBackgroundColor =>
      currentTheme.extension<_CustomColors>()!.cardBackgroundColor;
  Color get iconColor => currentTheme.extension<_CustomColors>()!.iconColor;
  Color get textColor => currentTheme.extension<_CustomColors>()!.textColor;
  Color get secondaryTextColor =>
      currentTheme.extension<_CustomColors>()!.secondaryTextColor;

  // إضافة خصائص إضافية للألوان
  Color get cardColor => currentTheme.cardColor;
  Color get primaryTextColor => textColor;
  Color get shadowColor => isDarkMode ? Colors.black26 : Colors.black12;
  Color get dividerColor => isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
  Color get surfaceColor => currentTheme.colorScheme.surface;
  Color get onSurfaceColor => currentTheme.colorScheme.onSurface;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      hintColor: Colors.amber,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black54),
      ),
      colorScheme: ColorScheme.light(
        primary: Colors.blue,
        secondary: Colors.amber,
        surface: Colors.white,
        onSurface: Colors.black87,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
      ),
      cardColor: Colors.white,
      dialogTheme: const DialogThemeData(
        backgroundColor: Colors.white,
      ), // Fixed: dialogBackgroundColor to DialogThemeData
      secondaryHeaderColor: Colors.grey[100],
      // Custom properties
      extensions: <ThemeExtension<dynamic>>[
        _CustomColors(
          primaryBackgroundColor: Colors.grey[50]!,
          secondaryBackgroundColor: Colors.white,
          cardBackgroundColor: Colors.white,
          iconColor: Colors.grey[700]!,
          textColor: Colors.black87,
          secondaryTextColor: Colors.grey[600]!,
        ),
      ],
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blue[300],
      hintColor: Colors.amber[300],
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      colorScheme: ColorScheme.dark(
        primary: Colors.blue[300]!,
        secondary: Colors.amber[300]!,
        surface: Colors.grey[900]!,
        onSurface: Colors.white,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
      ),
      cardColor: Colors.grey[900],
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.grey[900],
      ), // Fixed: dialogBackgroundColor to DialogThemeData
      secondaryHeaderColor: Colors.grey[800],
      // Custom properties
      extensions: <ThemeExtension<dynamic>>[
        _CustomColors(
          primaryBackgroundColor: Colors.black,
          secondaryBackgroundColor: Colors.grey[900]!,
          cardBackgroundColor: Colors.grey[850]!,
          iconColor: Colors.grey[300]!,
          textColor: Colors.white,
          secondaryTextColor: Colors.grey[400]!,
        ),
      ],
    );
  }
}

@immutable
class _CustomColors extends ThemeExtension<_CustomColors> {
  const _CustomColors({
    required this.primaryBackgroundColor,
    required this.secondaryBackgroundColor,
    required this.cardBackgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.secondaryTextColor,
  });

  final Color primaryBackgroundColor;
  final Color secondaryBackgroundColor;
  final Color cardBackgroundColor;
  final Color iconColor;
  final Color textColor;
  final Color secondaryTextColor;

  @override
  _CustomColors copyWith({
    Color? primaryBackgroundColor,
    Color? secondaryBackgroundColor,
    Color? cardBackgroundColor,
    Color? iconColor,
    Color? textColor,
    Color? secondaryTextColor,
  }) {
    return _CustomColors(
      primaryBackgroundColor:
          primaryBackgroundColor ?? this.primaryBackgroundColor,
      secondaryBackgroundColor:
          secondaryBackgroundColor ?? this.secondaryBackgroundColor,
      cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
      iconColor: iconColor ?? this.iconColor,
      textColor: textColor ?? this.textColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
    );
  }

  @override
  _CustomColors lerp(ThemeExtension<_CustomColors>? other, double t) {
    if (other is! _CustomColors) {
      return this;
    }
    return _CustomColors(
      primaryBackgroundColor: Color.lerp(
        primaryBackgroundColor,
        other.primaryBackgroundColor,
        t,
      )!,
      secondaryBackgroundColor: Color.lerp(
        secondaryBackgroundColor,
        other.secondaryBackgroundColor,
        t,
      )!,
      cardBackgroundColor: Color.lerp(
        cardBackgroundColor,
        other.cardBackgroundColor,
        t,
      )!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      secondaryTextColor: Color.lerp(
        secondaryTextColor,
        other.secondaryTextColor,
        t,
      )!,
    );
  }
}
