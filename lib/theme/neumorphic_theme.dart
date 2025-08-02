import 'package:flutter/material.dart';

// --- Neumorphic Dark Theme Colors ---
class NeumorphicDarkColors {
  static const Color bgColor = Color(0xFF2C313A);
  static const Color shadowDark = Color(0xFF242830);
  static const Color shadowLight = Color(0xFF343A44);
  static const Color textColor = Color(0xFFA0A8B4);
  static const Color highlightColor = Color(0xFFFFFFFF);
  static const Color accentColor = Color(0xFF4A9EFF);
}

// --- Neumorphic Light Theme Colors ---
class NeumorphicLightColors {
  static const Color bgColor = Color(0xFFF0F0F0);
  static const Color shadowDark = Color(0xFFD1D1D1);
  static const Color shadowLight = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF6B7280);
  static const Color highlightColor = Color(0xFF1F2937);
  static const Color accentColor = Color(0xFF3B82F6);
}

class NeumorphicTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: NeumorphicDarkColors.accentColor,
      scaffoldBackgroundColor: NeumorphicDarkColors.bgColor,
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: NeumorphicDarkColors.textColor),
        bodyMedium: TextStyle(color: NeumorphicDarkColors.textColor),
        headlineLarge: TextStyle(
          color: NeumorphicDarkColors.highlightColor,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: NeumorphicDarkColors.highlightColor,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: NeumorphicDarkColors.highlightColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      colorScheme: ColorScheme.dark(
        primary: NeumorphicDarkColors.accentColor,
        secondary: NeumorphicDarkColors.accentColor,
        surface: NeumorphicDarkColors.bgColor,
        onSurface: NeumorphicDarkColors.highlightColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      cardColor: NeumorphicDarkColors.bgColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: NeumorphicDarkColors.bgColor,
        foregroundColor: NeumorphicDarkColors.highlightColor,
        elevation: 0,
      ),
      extensions: <ThemeExtension<dynamic>>[
        NeumorphicColors(
          bgColor: NeumorphicDarkColors.bgColor,
          shadowDark: NeumorphicDarkColors.shadowDark,
          shadowLight: NeumorphicDarkColors.shadowLight,
          textColor: NeumorphicDarkColors.textColor,
          highlightColor: NeumorphicDarkColors.highlightColor,
          accentColor: NeumorphicDarkColors.accentColor,
        ),
      ],
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: NeumorphicLightColors.accentColor,
      scaffoldBackgroundColor: NeumorphicLightColors.bgColor,
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: NeumorphicLightColors.textColor),
        bodyMedium: TextStyle(color: NeumorphicLightColors.textColor),
        headlineLarge: TextStyle(
          color: NeumorphicLightColors.highlightColor,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: NeumorphicLightColors.highlightColor,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: NeumorphicLightColors.highlightColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: NeumorphicLightColors.accentColor,
        secondary: NeumorphicLightColors.accentColor,
        surface: NeumorphicLightColors.bgColor,
        onSurface: NeumorphicLightColors.highlightColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      cardColor: NeumorphicLightColors.bgColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: NeumorphicLightColors.bgColor,
        foregroundColor: NeumorphicLightColors.highlightColor,
        elevation: 0,
      ),
      extensions: <ThemeExtension<dynamic>>[
        NeumorphicColors(
          bgColor: NeumorphicLightColors.bgColor,
          shadowDark: NeumorphicLightColors.shadowDark,
          shadowLight: NeumorphicLightColors.shadowLight,
          textColor: NeumorphicLightColors.textColor,
          highlightColor: NeumorphicLightColors.highlightColor,
          accentColor: NeumorphicLightColors.accentColor,
        ),
      ],
    );
  }
}

@immutable
class NeumorphicColors extends ThemeExtension<NeumorphicColors> {
  const NeumorphicColors({
    required this.bgColor,
    required this.shadowDark,
    required this.shadowLight,
    required this.textColor,
    required this.highlightColor,
    required this.accentColor,
  });

  final Color bgColor;
  final Color shadowDark;
  final Color shadowLight;
  final Color textColor;
  final Color highlightColor;
  final Color accentColor;

  @override
  NeumorphicColors copyWith({
    Color? bgColor,
    Color? shadowDark,
    Color? shadowLight,
    Color? textColor,
    Color? highlightColor,
    Color? accentColor,
  }) {
    return NeumorphicColors(
      bgColor: bgColor ?? this.bgColor,
      shadowDark: shadowDark ?? this.shadowDark,
      shadowLight: shadowLight ?? this.shadowLight,
      textColor: textColor ?? this.textColor,
      highlightColor: highlightColor ?? this.highlightColor,
      accentColor: accentColor ?? this.accentColor,
    );
  }

  @override
  NeumorphicColors lerp(ThemeExtension<NeumorphicColors>? other, double t) {
    if (other is! NeumorphicColors) {
      return this;
    }
    return NeumorphicColors(
      bgColor: Color.lerp(bgColor, other.bgColor, t)!,
      shadowDark: Color.lerp(shadowDark, other.shadowDark, t)!,
      shadowLight: Color.lerp(shadowLight, other.shadowLight, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      highlightColor: Color.lerp(highlightColor, other.highlightColor, t)!,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
    );
  }
}

// Extension لسهولة الوصول للألوان
extension NeumorphicColorsExtension on ThemeData {
  NeumorphicColors get neumorphicColors {
    final extension = this.extension<NeumorphicColors>();
    if (extension != null) {
      return extension;
    }
    
    // إرجاع قيم افتراضية حسب brightness
    if (brightness == Brightness.dark) {
      return const NeumorphicColors(
        bgColor: NeumorphicDarkColors.bgColor,
        shadowDark: NeumorphicDarkColors.shadowDark,
        shadowLight: NeumorphicDarkColors.shadowLight,
        textColor: NeumorphicDarkColors.textColor,
        highlightColor: NeumorphicDarkColors.highlightColor,
        accentColor: NeumorphicDarkColors.accentColor,
      );
    } else {
      return const NeumorphicColors(
        bgColor: NeumorphicLightColors.bgColor,
        shadowDark: NeumorphicLightColors.shadowDark,
        shadowLight: NeumorphicLightColors.shadowLight,
        textColor: NeumorphicLightColors.textColor,
        highlightColor: NeumorphicLightColors.highlightColor,
        accentColor: NeumorphicLightColors.accentColor,
      );
    }
  }
}
