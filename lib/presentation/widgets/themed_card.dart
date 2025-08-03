import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';

class ThemedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const ThemedCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, ThemeProvider>(
      builder: (context, appProvider, themeProvider, child) {
        final uiKitType = appProvider.currentApp.uiKitType;
        
        Widget cardWidget;
        
        switch (uiKitType) {
          case 'modern':
            cardWidget = _buildModernCard(context, appProvider, themeProvider);
            break;
          case 'glassmorphic':
            cardWidget = _buildGlassmorphicCard(context, appProvider, themeProvider);
            break;
          case 'neomorphic':
            cardWidget = _buildNeomorphicCard(context, appProvider, themeProvider);
            break;
          case 'gradient':
            cardWidget = _buildGradientCard(context, appProvider, themeProvider);
            break;
          case 'minimal':
            cardWidget = _buildMinimalCard(context, appProvider, themeProvider);
            break;
          case 'cyber':
            cardWidget = _buildCyberCard(context, appProvider, themeProvider);
            break;
          case 'nature':
            cardWidget = _buildNatureCard(context, appProvider, themeProvider);
            break;
          case 'retro':
            cardWidget = _buildRetroCard(context, appProvider, themeProvider);
            break;
          case 'ocean':
            cardWidget = _buildOceanCard(context, appProvider, themeProvider);
            break;
          case 'sunset':
            cardWidget = _buildSunsetCard(context, appProvider, themeProvider);
            break;
          default:
            cardWidget = _buildModernCard(context, appProvider, themeProvider);
        }

        if (onTap != null) {
          return GestureDetector(
            onTap: onTap,
            child: cardWidget,
          );
        }
        
        return cardWidget;
      },
      child: this.child,
    );
  }

  Widget _buildModernCard(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.currentTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeProvider.currentTheme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildGlassmorphicCard(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(themeProvider.isDarkMode ? 0.1 : 0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildNeomorphicCard(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeProvider.currentTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: themeProvider.isDarkMode ? Colors.black54 : Colors.grey.shade400,
            offset: const Offset(8, 8),
            blurRadius: 15,
          ),
          BoxShadow(
            color: themeProvider.isDarkMode ? Colors.grey.shade800 : Colors.white,
            offset: const Offset(-8, -8),
            blurRadius: 15,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildGradientCard(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appProvider.currentApp.primaryColor.withOpacity(0.8),
            appProvider.currentApp.secondaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: appProvider.currentApp.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: child,
      ),
    );
  }

  Widget _buildMinimalCard(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.currentTheme.colorScheme.surface,
        border: Border.all(
          color: themeProvider.currentTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildCyberCard(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.currentTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: appProvider.currentApp.primaryColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: appProvider.currentApp.primaryColor.withOpacity(0.3),
            blurRadius: 15,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildNatureCard(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeProvider.currentTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: appProvider.currentApp.primaryColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildRetroCard(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.currentTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: appProvider.currentApp.primaryColor,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildOceanCard(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeProvider.currentTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: appProvider.currentApp.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSunsetCard(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appProvider.currentApp.primaryColor.withOpacity(0.9),
            appProvider.currentApp.secondaryColor.withOpacity(0.9),
            const Color(0xFFFFD23F).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: appProvider.currentApp.primaryColor.withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: child,
      ),
    );
  }
}