import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../utils/responsive_layout.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/app_navigation_bar.dart';
import '../pages/favorites_screen.dart';
import '../pages/settings_screen.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppProvider, ThemeProvider, LocaleProvider>(
      builder: (context, appProvider, themeProvider, localeProvider, child) {
        final isArabic = localeProvider.locale.languageCode == 'ar';
        final currentApp = appProvider.currentApp;
        final currentPage = appProvider.currentPage;

        // تحديث UI Kit حسب التطبيق المختار
        WidgetsBinding.instance.addPostFrameCallback((_) {
          themeProvider.setUiKit(currentApp.uiKitType);
        });

        return Scaffold(
          backgroundColor: themeProvider.currentTheme.colorScheme.surface,
          body: Directionality(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: GestureDetector(
              onTap: () {
                // إخفاء الشريط الجانبي عند الضغط على أي مكان خارج الشريط الجانبي نفسه
                if (!appProvider.isSidebarHidden) {
                  appProvider.hideSidebar();
                }
              },
              behavior: HitTestBehavior
                  .translucent, // عشان يستقبل الضغطات في المساحات الشفافة
              child: Stack(
                children: [
                  // Main content (full width, doesn't respond to sidebar)
                  Column(
                    children: [
                      // App Header
                      Container(
                        height: ResponsiveLayout.isSmallMobile(context)
                            ? 60
                            : 70,
                        decoration: BoxDecoration(
                          color: themeProvider.currentTheme.colorScheme.surface,
                          border: Border(
                            bottom: BorderSide(
                              color: themeProvider.currentTheme.dividerColor
                                  .withAlpha((0.1 * 255).round()),
                              width: 1,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(
                                (0.05 * 255).round(),
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveLayout.isSmallMobile(context)
                                ? 12
                                : 16,
                          ),
                          child: Row(
                            children: [
                              // Menu button (only visible when sidebar is hidden)
                              if (appProvider.isSidebarHidden)
                                Container(
                                  width: 36,
                                  height: 36,
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    color: currentApp.primaryColor.withValues(
                                      alpha: (currentApp.primaryColor.a * 0.1),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () {
                                        appProvider.showSidebar();
                                      },
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Icon(
                                          Icons.menu,
                                          color: currentApp.primaryColor,
                                          size:
                                              ResponsiveLayout.getNavigationIconSize(
                                                context,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              // App Icon with Modern Design
                              Container(
                                width: ResponsiveLayout.isSmallMobile(context)
                                    ? 32
                                    : 40,
                                height: ResponsiveLayout.isSmallMobile(context)
                                    ? 32
                                    : 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      currentApp.primaryColor,
                                      currentApp.secondaryColor,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: currentApp.primaryColor.withAlpha(
                                        ((currentApp.primaryColor.a *
                                                    0.3 *
                                                    255.0)
                                                .round() &
                                            0xff),
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Icon(
                                    currentApp.icon,
                                    color: Colors.white,
                                    size: ResponsiveLayout.getSmallIconSize(
                                      context,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: ResponsiveLayout.isSmallMobile(context)
                                    ? 8
                                    : 12,
                              ),

                              // Removed App Name and UI Kit Type

                              // Separator and Current Page
                              if (currentApp.pages.length > 1) ...[
                                SizedBox(
                                  width: ResponsiveLayout.isSmallMobile(context)
                                      ? 8
                                      : 12,
                                ),
                                Container(
                                  width: 1,
                                  height: 24,
                                  color: themeProvider.currentTheme.dividerColor
                                      .withAlpha((0.2 * 255).round()),
                                ),
                                SizedBox(
                                  width: ResponsiveLayout.isSmallMobile(context)
                                      ? 8
                                      : 12,
                                ),

                                // Removed Current Page Info
                              ],

                              SizedBox(
                                width: ResponsiveLayout.isSmallMobile(context)
                                    ? 6
                                    : 8,
                              ),

                              // Action Buttons
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Favorites Button
                                  Container(
                                    decoration: BoxDecoration(
                                      color: themeProvider
                                          .currentTheme
                                          .colorScheme
                                          .surfaceContainerHighest
                                          .withAlpha((0.5 * 255).round()),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.favorite_rounded,
                                        size:
                                            ResponsiveLayout.isSmallMobile(
                                              context,
                                            )
                                              ? 20
                                              : 22,
                                        color: themeProvider
                                            .currentTheme
                                            .colorScheme
                                            .onSurface,
                                      ),
                                      onPressed: () {
                                        appProvider.navigateToFavorites();
                                      },
                                      tooltip: isArabic ? 'المفضلة' : 'Favorites',
                                      padding:
                                          ResponsiveLayout.isSmallMobile(
                                            context,
                                          )
                                              ? const EdgeInsets.all(4)
                                              : const EdgeInsets.all(8),
                                    ),
                                  ),

                                  SizedBox(
                                    width:
                                        ResponsiveLayout.isSmallMobile(context)
                                        ? 6
                                        : 8,
                                  ),

                                  // Settings Button
                                  Container(
                                    decoration: BoxDecoration(
                                      color: themeProvider
                                          .currentTheme
                                          .colorScheme
                                          .surfaceContainerHighest
                                          .withAlpha((0.5 * 255).round()),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.settings_rounded,
                                        size:
                                            ResponsiveLayout.isSmallMobile(
                                              context,
                                            )
                                              ? 20
                                              : 22,
                                        color: themeProvider
                                            .currentTheme
                                            .colorScheme
                                            .onSurface,
                                      ),
                                      onPressed: () {
                                        appProvider.navigateToSettings();
                                      },
                                      tooltip: isArabic ? 'الإعدادات' : 'Settings',
                                      padding:
                                          ResponsiveLayout.isSmallMobile(
                                            context,
                                          )
                                              ? const EdgeInsets.all(4)
                                              : const EdgeInsets.all(8),
                                    ),
                                  ),

                                  SizedBox(
                                    width:
                                        ResponsiveLayout.isSmallMobile(context)
                                        ? 6
                                        : 8,
                                  ),

                                  // Theme Toggle with Modern Design
                                  Container(
                                    decoration: BoxDecoration(
                                      color: themeProvider
                                          .currentTheme
                                          .colorScheme
                                          .surfaceContainerHighest
                                          .withAlpha((0.5 * 255).round()),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        child: Icon(
                                          themeProvider.isDarkMode
                                              ? Icons.light_mode_rounded
                                              : Icons.dark_mode_rounded,
                                          key: ValueKey(
                                            themeProvider.isDarkMode,
                                          ),
                                          size:
                                              ResponsiveLayout.isSmallMobile(
                                                context,
                                              )
                                              ? 20
                                              : 22,
                                          color: themeProvider
                                              .currentTheme
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                      onPressed: () =>
                                          themeProvider.toggleTheme(),
                                      tooltip: isArabic
                                          ? (themeProvider.isDarkMode
                                                ? 'الوضع الفاتح'
                                                : 'الوضع الداكن')
                                          : (themeProvider.isDarkMode
                                                ? 'Light Mode'
                                                : 'Dark Mode'),
                                      padding:
                                          ResponsiveLayout.isSmallMobile(
                                            context,
                                          )
                                              ? const EdgeInsets.all(4)
                                              : const EdgeInsets.all(8),
                                    ),
                                  ),

                                  SizedBox(
                                    width:
                                        ResponsiveLayout.isSmallMobile(context)
                                        ? 6
                                        : 8,
                                  ),

                                  // Language Toggle
                                  Container(
                                    decoration: BoxDecoration(
                                      color: themeProvider
                                          .currentTheme
                                          .colorScheme
                                          .surfaceContainerHighest
                                          .withAlpha((0.5 * 255).round()),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.language_rounded,
                                        size:
                                            ResponsiveLayout.isSmallMobile(
                                              context,
                                            )
                                              ? 20
                                              : 22,
                                      ),
                                      onPressed: () =>
                                          localeProvider.toggleLocale(),
                                      tooltip: isArabic ? 'English' : 'العربية',
                                      color: themeProvider
                                          .currentTheme
                                          .colorScheme
                                          .onSurface,
                                      padding:
                                          ResponsiveLayout.isSmallMobile(
                                            context,
                                          )
                                              ? const EdgeInsets.all(4)
                                              : const EdgeInsets.all(8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Page Content (takes full width)
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(0.05, 0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            key: ValueKey('${currentApp.id}_${currentPage.id}'),
                            child: appProvider.showFavorites
                                ? const FavoritesScreen()
                                : appProvider.showSettings
                                    ? const SettingsScreen()
                                    : currentPage.screen,
                          ),
                        ),
                      ),

                      // Navigation Bar for current app
                      const AppNavigationBar(),
                    ],
                  ),

                  // Sidebar - floating above content
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    top: 0,
                    bottom: 0,
                    right: isArabic
                        ? (appProvider.isSidebarHidden
                              ? -ResponsiveLayout.getSidebarWidth(
                                  context,
                                ) // Move completely off-screen
                              : 0)
                        : null,
                    left: isArabic
                        ? null
                        : (appProvider.isSidebarHidden
                              ? -ResponsiveLayout.getSidebarWidth(
                                  context,
                                ) // Move completely off-screen
                              : 0),
                    width: ResponsiveLayout.getSidebarWidth(context),
                    child: Material(
                      elevation: 8,
                      color: Colors.transparent,
                      child: const AppSidebar(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
