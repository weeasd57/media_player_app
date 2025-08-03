import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/app_navigation_bar.dart';

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
            child: Stack(
              children: [
                // Main content (full width, doesn't respond to sidebar)
                Column(
                  children: [
                    // App Header
                    Container(
                      height: 70,
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
                            color: Colors.black.withAlpha((0.05 * 255).round()),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            // Menu button (only visible when sidebar is hidden)
                            if (appProvider.isSidebarHidden)
                              Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: currentApp.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      appProvider.showSidebar();
                                      debugPrint("Show sidebar button pressed");
                                    },
                                    child: Icon(
                                      Icons.menu,
                                      color: currentApp.primaryColor,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),

                            // App Icon with Modern Design
                            Container(
                              width: 40,
                              height: 40,
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
                                      (0.3 * 255).round(),
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                currentApp.icon,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // App Name and UI Kit Type
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isArabic
                                      ? currentApp.nameAr
                                      : currentApp.name,
                                  style: themeProvider
                                      .currentTheme
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: themeProvider
                                            .currentTheme
                                            .colorScheme
                                            .onSurface,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                ),
                                Text(
                                  '${currentApp.uiKitType.toUpperCase()} UI KIT',
                                  style: themeProvider
                                      .currentTheme
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: themeProvider
                                            .currentTheme
                                            .colorScheme
                                            .onSurface
                                            .withAlpha((0.6 * 255).round()),
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.8,
                                      ),
                                ),
                              ],
                            ),

                            // Separator and Current Page
                            if (currentApp.pages.length > 1) ...[
                              const SizedBox(width: 16),
                              Container(
                                width: 1,
                                height: 30,
                                color: themeProvider.currentTheme.dividerColor
                                    .withAlpha((0.2 * 255).round()),
                              ),
                              const SizedBox(width: 16),

                              // Current Page Info
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Current Page',
                                    style: themeProvider
                                        .currentTheme
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: themeProvider
                                              .currentTheme
                                              .colorScheme
                                              .onSurface
                                              .withAlpha((0.5 * 255).round()),
                                          fontSize: 10,
                                        ),
                                  ),
                                  Text(
                                    isArabic
                                        ? currentPage.nameAr
                                        : currentPage.name,
                                    style: themeProvider
                                        .currentTheme
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: themeProvider
                                              .currentTheme
                                              .colorScheme
                                              .onSurface
                                              .withAlpha((0.8 * 255).round()),
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ],

                            const Spacer(),

                            // Action Buttons
                            Row(
                              children: [
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
                                        key: ValueKey(themeProvider.isDarkMode),
                                        size: 22,
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
                                  ),
                                ),

                                const SizedBox(width: 8),

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
                                    icon: const Icon(
                                      Icons.language_rounded,
                                      size: 22,
                                    ),
                                    onPressed: () =>
                                        localeProvider.toggleLocale(),
                                    tooltip: isArabic ? 'English' : 'العربية',
                                    color: themeProvider
                                        .currentTheme
                                        .colorScheme
                                        .onSurface,
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
                          child: currentPage.screen,
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
                            ? -280 // Move completely off-screen
                            : 0)
                      : null,
                  left: isArabic
                      ? null
                      : (appProvider.isSidebarHidden
                            ? -280 // Move completely off-screen
                            : 0),
                  width: appProvider.isSidebarCollapsed ? 70 : 280,
                  child: Material(
                    elevation: 8,
                    color: Colors.transparent,
                    child: const AppSidebar(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
