import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppProvider, ThemeProvider, LocaleProvider>(
      builder: (context, appProvider, themeProvider, localeProvider, child) {
        final isArabic = localeProvider.locale.languageCode == 'ar';
        
        return Container(
          width: 280,
          decoration: BoxDecoration(
            color: themeProvider.currentTheme.colorScheme.surface,
            border: Border(
              right: BorderSide(
                color: themeProvider.currentTheme.dividerColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: themeProvider.currentTheme.colorScheme.primary.withOpacity(0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: themeProvider.currentTheme.dividerColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.apps,
                      color: themeProvider.currentTheme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isArabic ? 'التطبيقات' : 'Applications',
                      style: themeProvider.currentTheme.textTheme.titleLarge?.copyWith(
                        color: themeProvider.currentTheme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Apps List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: appProvider.apps.length,
                  itemBuilder: (context, index) {
                    final app = appProvider.apps[index];
                    final isSelected = appProvider.selectedAppIndex == index;
                    
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected 
                          ? app.primaryColor.withOpacity(0.1)
                          : Colors.transparent,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => appProvider.selectApp(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                      ? app.primaryColor 
                                      : app.primaryColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    app.icon,
                                    color: isSelected 
                                      ? Colors.white 
                                      : app.primaryColor,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isArabic ? app.nameAr : app.name,
                                        style: themeProvider.currentTheme.textTheme.titleMedium?.copyWith(
                                          color: isSelected 
                                            ? app.primaryColor 
                                            : themeProvider.currentTheme.colorScheme.onSurface,
                                          fontWeight: isSelected 
                                            ? FontWeight.w600 
                                            : FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${app.pages.length} ${isArabic ? 'صفحة' : 'pages'}',
                                        style: themeProvider.currentTheme.textTheme.bodySmall?.copyWith(
                                          color: themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: app.primaryColor,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: themeProvider.currentTheme.dividerColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: themeProvider.currentTheme.colorScheme.primary.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        color: themeProvider.currentTheme.colorScheme.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isArabic ? 'المستخدم' : 'User',
                        style: themeProvider.currentTheme.textTheme.bodyMedium?.copyWith(
                          color: themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
