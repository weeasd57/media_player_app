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
          height: 70,
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
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: currentApp.pages.asMap().entries.map((entry) {
              final index = entry.key;
              final page = entry.value;
              final isSelected = appProvider.selectedPageIndex == index;
              
              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => appProvider.selectPage(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isSelected 
                                ? currentApp.primaryColor.withOpacity(0.15)
                                : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              page.icon,
                              color: isSelected 
                                ? currentApp.primaryColor 
                                : themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.6),
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isArabic ? page.nameAr : page.name,
                            style: themeProvider.currentTheme.textTheme.labelSmall?.copyWith(
                              color: isSelected 
                                ? currentApp.primaryColor 
                                : themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
