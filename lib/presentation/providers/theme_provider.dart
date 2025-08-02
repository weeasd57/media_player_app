import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/neumorphic_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  static const String _themeKey = 'themeMode'; // New: Key for SharedPreferences

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark; // New: isDarkMode getter

  ThemeProvider() {
    _loadTheme(); // New: Load theme on initialization
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey);
    if (themeIndex != null) {
      _themeMode = ThemeMode.values[themeIndex];
      notifyListeners();
    }
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  // استخدام نظام Neumorphic
  ThemeData get currentTheme => _themeMode == ThemeMode.dark
      ? NeumorphicTheme.darkTheme
      : NeumorphicTheme.lightTheme;

  // Neumorphic colors getters
  NeumorphicColors get neumorphicColors => currentTheme.neumorphicColors;

  Color get primaryBackgroundColor => neumorphicColors.bgColor;
  Color get secondaryBackgroundColor => neumorphicColors.bgColor;
  Color get cardBackgroundColor => neumorphicColors.bgColor;
  Color get iconColor => neumorphicColors.textColor;
  Color get textColor => neumorphicColors.textColor;
  Color get secondaryTextColor => neumorphicColors.textColor;
  Color get highlightColor => neumorphicColors.highlightColor;
  Color get accentColor => neumorphicColors.accentColor;
  Color get shadowDark => neumorphicColors.shadowDark;
  Color get shadowLight => neumorphicColors.shadowLight;

  // إضافة خصائص إضافية للألوان
  Color get cardColor => neumorphicColors.bgColor;
  Color get primaryTextColor => neumorphicColors.highlightColor;
  Color get shadowColor => neumorphicColors.shadowDark;
  Color get dividerColor => neumorphicColors.shadowDark;
  Color get surfaceColor => neumorphicColors.bgColor;
  Color get onSurfaceColor => neumorphicColors.highlightColor;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _saveTheme(_themeMode); // New: Save theme on toggle
    notifyListeners();
  }
  
  void setTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _saveTheme(_themeMode); // New: Save theme on toggle
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
    const darkBg = Color(0xFF1A1A1A);
    const cardBg = Color(0xFF2D2D2D);
    const primaryColor = Color(0xFF4A9EFF);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      hintColor: primaryColor,
      scaffoldBackgroundColor: darkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBg,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor,
        surface: darkBg,
        onSurface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      cardColor: cardBg,
      dialogTheme: const DialogThemeData(backgroundColor: cardBg),
      secondaryHeaderColor: cardBg,
      // Custom properties
      extensions: <ThemeExtension<dynamic>>[
        _CustomColors(
          primaryBackgroundColor: darkBg,
          secondaryBackgroundColor: cardBg,
          cardBackgroundColor: cardBg,
          iconColor: Colors.white70,
          textColor: Colors.white,
          secondaryTextColor: Colors.white60,
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
