import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppProvider, ThemeProvider, LocaleProvider>(
      builder: (context, appProvider, themeProvider, localeProvider, child) {
        final currentApp = appProvider.currentApp;
        final isArabic = localeProvider.locale.languageCode == 'ar';
        
        if (currentApp.pages.length <= 1) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: themeProvider.currentTheme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: themeProvider.currentTheme.dividerColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: _buildNavigationContent(
            context,
            appProvider,
            themeProvider,
            isArabic,
            currentApp.uiKitType,
          ),
        );
      },
    );
  }

  Widget _buildNavigationContent(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
    String uiKitType,
  ) {
    switch (uiKitType) {
      case 'modern':
        return _buildModernNavigation(context, appProvider, themeProvider, isArabic);
      case 'glassmorphic':
        return _buildGlassmorphicNavigation(context, appProvider, themeProvider, isArabic);
      case 'neomorphic':
        return _buildNeomorphicNavigation(context, appProvider, themeProvider, isArabic);
      case 'gradient':
        return _buildGradientNavigation(context, appProvider, themeProvider, isArabic);
      case 'minimal':
        return _buildMinimalNavigation(context, appProvider, themeProvider, isArabic);
      case 'cyber':
        return _buildCyberNavigation(context, appProvider, themeProvider, isArabic);
      case 'nature':
        return _buildNatureNavigation(context, appProvider, themeProvider, isArabic);
      case 'retro':
        return _buildRetroNavigation(context, appProvider, themeProvider, isArabic);
      case 'ocean':
        return _buildOceanNavigation(context, appProvider, themeProvider, isArabic);
      case 'sunset':
        return _buildSunsetNavigation(context, appProvider, themeProvider, isArabic);
      default:
        return _buildModernNavigation(context, appProvider, themeProvider, isArabic);
    }
  }

  // Modern Navigation
  Widget _buildModernNavigation(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: appProvider.currentApp.pages.asMap().entries.map((entry) {
          final index = entry.key;
          final page = entry.value;
          final isSelected = appProvider.selectedPageIndex == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => appProvider.selectPage(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? appProvider.currentApp.primaryColor.withOpacity(0.15)
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected 
                          ? appProvider.currentApp.primaryColor
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        page.icon,
                        color: isSelected 
                          ? Colors.white
                          : themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.6),
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isArabic ? page.nameAr : page.name,
                      style: themeProvider.currentTheme.textTheme.labelSmall?.copyWith(
                        color: isSelected 
                          ? appProvider.currentApp.primaryColor
                          : themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Glassmorphic Navigation
  Widget _buildGlassmorphicNavigation(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(themeProvider.isDarkMode ? 0.1 : 0.7),
        borderRadius: BorderRadius.circular(25),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: _buildNavigationItems(appProvider, themeProvider, isArabic, 'glassmorphic'),
        ),
      ),
    );
  }

  // Neomorphic Navigation
  Widget _buildNeomorphicNavigation(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
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
      child: _buildNavigationItems(appProvider, themeProvider, isArabic, 'neomorphic'),
    );
  }

  // Add other navigation styles...
  Widget _buildGradientNavigation(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appProvider.currentApp.primaryColor,
            appProvider.currentApp.secondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: appProvider.currentApp.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: _buildNavigationItems(appProvider, themeProvider, isArabic, 'gradient'),
    );
  }

  Widget _buildMinimalNavigation(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.currentTheme.colorScheme.surface,
        border: Border.all(
          color: themeProvider.currentTheme.dividerColor,
          width: 1,
        ),
      ),
      child: _buildNavigationItems(appProvider, themeProvider, isArabic, 'minimal'),
    );
  }

  Widget _buildCyberNavigation(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.currentTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: appProvider.currentApp.primaryColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: appProvider.currentApp.primaryColor.withOpacity(0.5),
            blurRadius: 20,
          ),
        ],
      ),
      child: _buildNavigationItems(appProvider, themeProvider, isArabic, 'cyber'),
    );
  }

  Widget _buildNatureNavigation(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.currentTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: appProvider.currentApp.primaryColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: _buildNavigationItems(appProvider, themeProvider, isArabic, 'nature'),
    );
  }

  Widget _buildRetroNavigation(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.currentTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: appProvider.currentApp.primaryColor,
          width: 3,
        ),
      ),
      child: _buildNavigationItems(appProvider, themeProvider, isArabic, 'retro'),
    );
  }

  Widget _buildOceanNavigation(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.currentTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: appProvider.currentApp.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: _buildNavigationItems(appProvider, themeProvider, isArabic, 'ocean'),
    );
  }

  Widget _buildSunsetNavigation(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appProvider.currentApp.primaryColor.withOpacity(0.8),
            appProvider.currentApp.secondaryColor.withOpacity(0.8),
            const Color(0xFFFFD23F).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: appProvider.currentApp.primaryColor.withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: _buildNavigationItems(appProvider, themeProvider, isArabic, 'sunset'),
    );
  }

  Widget _buildNavigationItems(
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
    String style,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: appProvider.currentApp.pages.asMap().entries.map((entry) {
          final index = entry.key;
          final page = entry.value;
          final isSelected = appProvider.selectedPageIndex == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => appProvider.selectPage(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      page.icon,
                      color: _getIconColor(isSelected, style, appProvider, themeProvider),
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isArabic ? page.nameAr : page.name,
                      style: themeProvider.currentTheme.textTheme.labelSmall?.copyWith(
                        color: _getTextColor(isSelected, style, appProvider, themeProvider),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getIconColor(bool isSelected, String style, AppProvider appProvider, ThemeProvider themeProvider) {
    if (style == 'gradient' || style == 'sunset') {
      return Colors.white;
    }
    return isSelected 
      ? appProvider.currentApp.primaryColor
      : themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.6);
  }

  Color _getTextColor(bool isSelected, String style, AppProvider appProvider, ThemeProvider themeProvider) {
    if (style == 'gradient' || style == 'sunset') {
      return Colors.white;
    }
    return isSelected 
      ? appProvider.currentApp.primaryColor
      : themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.6);
  }
}
