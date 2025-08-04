import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../utils/responsive_layout.dart';

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

        // Responsive height for navigation bar
        final navigationHeight = ResponsiveLayout.getValue(
          context,
          mobile: 70.0,
          tablet: 80.0,
          desktop: 90.0,
        );

        return Container(
          width: double.infinity,
          height: navigationHeight,
          decoration: BoxDecoration(
            color: themeProvider.currentTheme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: themeProvider.currentTheme.dividerColor.withAlpha(
                  (0.1 * 255).round(),
                ),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.05 * 255).round()),
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
        return _buildModernNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'glassmorphic':
        return _buildGlassmorphicNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'neomorphic':
        return _buildNeomorphicNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'gradient':
        return _buildGradientNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'minimal':
        return _buildMinimalNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'cyber':
        return _buildCyberNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'nature':
        return _buildNatureNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'retro':
        return _buildRetroNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'ocean':
        return _buildOceanNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'sunset':
        return _buildSunsetNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'neon':
        return _buildNeonNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'material_you':
        return _buildMaterialYouNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'dark_matter':
        return _buildDarkMatterNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'holographic':
        return _buildHolographicNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'vintage':
        return _buildVintageNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'crystal':
        return _buildCrystalNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'synthwave':
        return _buildSynthwaveNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'nordic':
        return _buildNordicNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'cosmic':
        return _buildCosmicNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      case 'brutalist':
        return _buildBrutalistNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        );
      default:
        return _buildModernNavigation(
          context,
          appProvider,
          themeProvider,
          isArabic,
        ); // Fallback
    }
  }

  // Modern Navigation
  Widget _buildModernNavigation(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
  ) {
    final isSmallScreen = ResponsiveLayout.isSmallMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 24,
        vertical: isSmallScreen ? 6 : 12,
      ),
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
                margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 1 : 4),
                padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 6 : 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? appProvider.currentApp.primaryColor.withAlpha(
                          (0.15 * 255).round(),
                        )
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.all(isSmallScreen ? 4 : 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? appProvider.currentApp.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Icon(
                          page.icon,
                          color: isSelected
                              ? Colors.white
                              : themeProvider.currentTheme.colorScheme.onSurface
                                    .withAlpha((0.6 * 255).round()),
                          size: ResponsiveLayout.getNavigationIconSize(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        isArabic ? page.nameAr : page.name,
                        style: themeProvider.currentTheme.textTheme.labelSmall
                            ?.copyWith(
                              color: isSelected
                                  ? appProvider.currentApp.primaryColor
                                  : themeProvider
                                        .currentTheme
                                        .colorScheme
                                        .onSurface
                                        .withAlpha((0.6 * 255).round()),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              fontSize: ResponsiveLayout.getValue(
                                context,
                                mobile: isSmallScreen ? 8 : 10,
                                tablet: 11,
                                desktop: 12,
                              ),
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(
                (themeProvider.isDarkMode ? (0.1 * 255) : (0.7 * 255)).round(),
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withAlpha((0.2 * 255).round()),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).round()),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: _buildNavigationItems(
              context,
              appProvider,
              themeProvider,
              isArabic,
              'glassmorphic',
            ),
          ),
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
            color: themeProvider.isDarkMode
                ? Colors.black54
                : Colors.grey.shade400,
            offset: const Offset(8, 8),
            blurRadius: 15,
          ),
          BoxShadow(
            color: themeProvider.isDarkMode
                ? Colors.grey.shade800
                : Colors.white,
            offset: const Offset(-8, -8),
            blurRadius: 15,
          ),
        ],
      ),
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'neomorphic',
      ),
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
            appProvider.currentApp.primaryColor.withAlpha((0.8 * 255).round()),
            appProvider.currentApp.secondaryColor.withAlpha(
              (0.8 * 255).round(),
            ),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: appProvider.currentApp.primaryColor.withAlpha(
              (0.3 * 255).round(),
            ),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'gradient',
      ),
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
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'minimal',
      ),
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
            color: appProvider.currentApp.primaryColor.withAlpha(
              (0.5 * 255).round(),
            ),
            blurRadius: 20,
          ),
        ],
      ),
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'cyber',
      ),
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
            color: appProvider.currentApp.primaryColor.withAlpha(
              (0.2 * 255).round(),
            ),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'nature',
      ),
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
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'retro',
      ),
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
            color: appProvider.currentApp.primaryColor.withAlpha(
              (0.3 * 255).round(),
            ),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'ocean',
      ),
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
            appProvider.currentApp.primaryColor.withAlpha((0.8 * 255).round()),
            appProvider.currentApp.secondaryColor.withAlpha(
              (0.8 * 255).round(),
            ),
            const Color(0xFFFFD23F).withAlpha((0.8 * 255).round()),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: appProvider.currentApp.primaryColor.withAlpha(
              (0.4 * 255).round(),
            ),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'sunset',
      ),
    );
  }

  Widget _buildNavigationItems(
    BuildContext context,
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
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Icon(
                        page.icon,
                        color: _getIconColor(
                          isSelected,
                          style,
                          appProvider,
                          themeProvider,
                        ),
                        size: ResponsiveLayout.getNavigationIconSize(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        isArabic ? page.nameAr : page.name,
                        style: themeProvider.currentTheme.textTheme.labelSmall
                            ?.copyWith(
                              color: _getTextColor(
                                isSelected,
                                style,
                                appProvider,
                                themeProvider,
                              ),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              fontSize: ResponsiveLayout.getValue(
                                context,
                                mobile: ResponsiveLayout.isSmallMobile(context)
                                    ? 9
                                    : 10,
                                tablet: 11,
                                desktop: 12,
                              ),
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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

  Color _getIconColor(
    bool isSelected,
    String style,
    AppProvider appProvider,
    ThemeProvider themeProvider,
  ) {
    if (style == 'gradient' || style == 'sunset') {
      return Colors.white;
    }
    return isSelected
        ? appProvider.currentApp.primaryColor
        : themeProvider.currentTheme.colorScheme.onSurface.withAlpha(
            (0.6 * 255).round(),
          );
  }

  Color _getTextColor(
    bool isSelected,
    String style,
    AppProvider appProvider,
    ThemeProvider themeProvider,
  ) {
    if (style == 'gradient' || style == 'sunset') {
      return Colors.white;
    }
    return isSelected
        ? appProvider.currentApp.primaryColor
        : themeProvider.currentTheme.colorScheme.onSurface.withAlpha(
            (0.6 * 255).round(),
          );
  }

  // 11. Neon Navigation
  Widget _buildNeonNavigation(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: appProvider.currentApp.primaryColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: appProvider.currentApp.primaryColor.withAlpha(
              (0.8 * 255).round(),
            ),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'neon',
      ),
    );
  }

  // 12. Material You Navigation
  Widget _buildMaterialYouNavigation(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.currentTheme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: themeProvider.currentTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'material_you',
      ),
    );
  }

  // 13. Dark Matter Navigation
  Widget _buildDarkMatterNavigation(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF333333), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.9 * 255).round()),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'dark_matter',
      ),
    );
  }

  // 14. Holographic Navigation
  Widget _buildHolographicNavigation(
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
            appProvider.currentApp.primaryColor.withAlpha((0.3 * 255).round()),
            appProvider.currentApp.secondaryColor.withAlpha(
              (0.3 * 255).round(),
            ),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withAlpha((0.3 * 255).round()),
          width: 1,
        ),
      ),
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'holographic',
      ),
    );
  }

  // 15. Vintage Navigation
  Widget _buildVintageNavigation(
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
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withAlpha((0.3 * 255).round()),
            blurRadius: 15,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'vintage',
      ),
    );
  }

  // 16. Crystal Navigation
  Widget _buildCrystalNavigation(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: appProvider.currentApp.primaryColor.withAlpha(
            (0.5 * 255).round(),
          ),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: appProvider.currentApp.primaryColor.withAlpha(
              (0.2 * 255).round(),
            ),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'crystal',
      ),
    );
  }

  // 17. Synthwave Navigation
  Widget _buildSynthwaveNavigation(
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
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
            const Color(0xFF0F3460),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: appProvider.currentApp.primaryColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: appProvider.currentApp.primaryColor.withAlpha(
              (0.6 * 255).round(),
            ),
            blurRadius: 20,
          ),
        ],
      ),
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'synthwave',
      ),
    );
  }

  // 18. Nordic Navigation
  Widget _buildNordicNavigation(
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
        border: Border.all(color: const Color(0xFF90A4AE), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.2 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'nordic',
      ),
    );
  }

  // 19. Cosmic Navigation
  Widget _buildCosmicNavigation(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            appProvider.currentApp.primaryColor.withAlpha((0.3 * 255).round()),
            appProvider.currentApp.secondaryColor.withAlpha(
              (0.2 * 255).round(),
            ),
            Colors.black.withAlpha((0.8 * 255).round()),
          ],
          center: Alignment.center,
          radius: 1.5,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: appProvider.currentApp.primaryColor.withAlpha(
              (0.4 * 255).round(),
            ),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'cosmic',
      ),
    );
  }

  // 20. Brutalist Navigation
  Widget _buildBrutalistNavigation(
    BuildContext context,
    AppProvider appProvider,
    ThemeProvider themeProvider,
    bool isArabic,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.currentTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(0), // Sharp edges
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.5 * 255).round()),
            blurRadius: 0,
            offset: const Offset(6, 6),
          ),
        ],
      ),
      child: _buildNavigationItems(
        context,
        appProvider,
        themeProvider,
        isArabic,
        'brutalist',
      ),
    );
  }
}
