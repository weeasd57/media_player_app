import 'package:flutter/material.dart';
import '../apps/modern_app/modern_theme.dart';
import '../apps/glassmorphic_app/glassmorphic_theme.dart';
import '../apps/neomorphic_app/neomorphic_theme.dart';
import '../apps/gradient_app/gradient_theme.dart';
import '../apps/minimal_app/minimal_theme.dart';
import '../apps/cyber_app/cyber_theme.dart';
import '../apps/nature_app/nature_theme.dart';
import '../apps/retro_app/retro_theme.dart';
import '../apps/ocean_app/ocean_theme.dart';
import '../apps/sunset_app/sunset_theme.dart';
// New Themes
import '../apps/neon_app/neon_theme.dart';
import '../apps/material_you_app/material_you_theme.dart';
import '../apps/dark_matter_app/dark_matter_theme.dart';
import '../apps/holographic_app/holographic_theme.dart';
import '../apps/vintage_app/vintage_theme.dart';
import '../apps/crystal_app/crystal_theme.dart';
import '../apps/synthwave_app/synthwave_theme.dart';
import '../apps/nordic_app/nordic_theme.dart';
import '../apps/cosmic_app/cosmic_theme.dart';
import '../apps/brutalist_app/brutalist_theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _currentUiKit = 'modern';

  bool get isDarkMode => _isDarkMode;
  String get currentUiKit => _currentUiKit;

  Color get primaryBackgroundColor => currentTheme.colorScheme.surface;

  ThemeData get currentTheme {
    switch (_currentUiKit) {
      case 'modern':
        return _isDarkMode ? ModernTheme.darkTheme : ModernTheme.lightTheme;
      case 'glassmorphic':
        return _isDarkMode
            ? GlassmorphicTheme.darkTheme
            : GlassmorphicTheme.lightTheme;
      case 'neomorphic':
        return _isDarkMode
            ? NeomorphicTheme.darkTheme
            : NeomorphicTheme.lightTheme;
      case 'gradient':
        return _isDarkMode ? GradientTheme.darkTheme : GradientTheme.lightTheme;
      case 'minimal':
        return _isDarkMode ? MinimalTheme.darkTheme : MinimalTheme.lightTheme;
      case 'cyber':
        return _isDarkMode ? CyberTheme.darkTheme : CyberTheme.lightTheme;
      case 'nature':
        return _isDarkMode ? NatureTheme.darkTheme : NatureTheme.lightTheme;
      case 'retro':
        return _isDarkMode ? RetroTheme.darkTheme : RetroTheme.lightTheme;
      case 'ocean':
        return _isDarkMode ? OceanTheme.darkTheme : OceanTheme.lightTheme;
      case 'sunset':
        return _isDarkMode ? SunsetTheme.darkTheme : SunsetTheme.lightTheme;
      case 'neon':
        return _isDarkMode ? NeonTheme.darkTheme : NeonTheme.lightTheme;
      case 'material_you':
        return _isDarkMode ? MaterialYouTheme.darkTheme : MaterialYouTheme.lightTheme;
      case 'dark_matter':
        return _isDarkMode ? DarkMatterTheme.darkTheme : DarkMatterTheme.lightTheme;
      case 'holographic':
        return _isDarkMode ? HolographicTheme.darkTheme : HolographicTheme.lightTheme;
      case 'vintage':
        return _isDarkMode ? VintageTheme.darkTheme : VintageTheme.lightTheme;
      case 'crystal':
        return _isDarkMode ? CrystalTheme.darkTheme : CrystalTheme.lightTheme;
      case 'synthwave':
        return _isDarkMode ? SynthwaveTheme.darkTheme : SynthwaveTheme.lightTheme;
      case 'nordic':
        return _isDarkMode ? NordicTheme.darkTheme : NordicTheme.lightTheme;
      case 'cosmic':
        return _isDarkMode ? CosmicTheme.darkTheme : CosmicTheme.lightTheme;
      case 'brutalist':
        return _isDarkMode ? BrutalistTheme.darkTheme : BrutalistTheme.lightTheme;
      default:
        return _isDarkMode ? ModernTheme.darkTheme : ModernTheme.lightTheme;
    }
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setUiKit(String uiKitType) {
    if (_currentUiKit != uiKitType) {
      _currentUiKit = uiKitType;
      notifyListeners();
    }
  }

  void setDarkMode(bool isDark) {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      notifyListeners();
    }
  }
}
