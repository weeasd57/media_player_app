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
        
        return Scaffold(
          backgroundColor: themeProvider.currentTheme.colorScheme.surface,
          body: Directionality(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: Row(
              children: [
                // Sidebar
                const AppSidebar(),
                
                // Main Content Area
                Expanded(
                  child: Column(
                    children: [
                      // App Header
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: themeProvider.currentTheme.colorScheme.surface,
                          border: Border(
                            bottom: BorderSide(
                              color: themeProvider.currentTheme.dividerColor.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              // App Icon
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: currentApp.primaryColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  currentApp.icon,
                                  color: currentApp.primaryColor,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              
                              // App Name
                              Text(
                                isArabic ? currentApp.nameAr : currentApp.name,
                                style: themeProvider.currentTheme.textTheme.titleMedium?.copyWith(
                                  color: themeProvider.currentTheme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              
                              // Separator
                              if (currentApp.pages.length > 1) ...[
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: themeProvider.currentTheme.colorScheme.onSurface.withValues(alpha: 0.4),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                
                                // Current Page Name
                                Text(
                                  isArabic ? currentPage.nameAr : currentPage.name,
                                  style: themeProvider.currentTheme.textTheme.titleMedium?.copyWith(
                                    color: themeProvider.currentTheme.colorScheme.onSurface.withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                              
                              const Spacer(),
                              
                              // Action Buttons
                              Row(
                                children: [
                                  // Theme Toggle
                                  IconButton(
                                    icon: Icon(
                                      themeProvider.isDarkMode 
                                        ? Icons.light_mode 
                                        : Icons.dark_mode,
                                      size: 20,
                                    ),
                                    onPressed: () => themeProvider.toggleTheme(),
                                    tooltip: isArabic 
                                      ? (themeProvider.isDarkMode ? 'الوضع الفاتح' : 'الوضع الداكن')
                                      : (themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode'),
                                  ),
                                  
                                  // Language Toggle
                                  IconButton(
                                    icon: const Icon(Icons.language, size: 20),
                                    onPressed: () => localeProvider.toggleLocale(),
                                    tooltip: isArabic ? 'English' : 'العربية',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Page Content
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.1, 0),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                )),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
