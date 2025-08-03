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
                blurRadius: 20,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: themeProvider.currentTheme.dividerColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Logo
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667EEA).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.widgets_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Title
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'مجموعة واجهات' : 'UI Kit Collection',
                            style: themeProvider.currentTheme.textTheme.titleMedium?.copyWith(
                              color: themeProvider.currentTheme.colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '10 ${isArabic ? 'أنماط مختلفة' : 'Different Styles'}',
                            style: themeProvider.currentTheme.textTheme.labelSmall?.copyWith(
                              color: themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Apps Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: appProvider.apps.length,
                    itemBuilder: (context, index) {
                      final app = appProvider.apps[index];
                      final isSelected = appProvider.selectedAppIndex == index;
                      
                      return GestureDetector(
                        onTap: () => appProvider.selectApp(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          decoration: BoxDecoration(
                            color: isSelected 
                              ? app.primaryColor.withOpacity(0.1)
                              : themeProvider.currentTheme.colorScheme.surfaceVariant.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected 
                                ? app.primaryColor.withOpacity(0.5)
                                : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: isSelected ? [
                              BoxShadow(
                                color: app.primaryColor.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ] : [],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // App Icon
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: isSelected ? 44 : 40,
                                  height: isSelected ? 44 : 40,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [app.primaryColor, app.secondaryColor],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: app.primaryColor.withOpacity(isSelected ? 0.4 : 0.2),
                                        blurRadius: isSelected ? 16 : 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    app.icon,
                                    color: Colors.white,
                                    size: isSelected ? 22 : 20,
                                  ),
                                ),
                                
                                const SizedBox(height: 12),
                                
                                // App Name
                                Text(
                                  isArabic ? app.nameAr : app.name,
                                  style: themeProvider.currentTheme.textTheme.titleSmall?.copyWith(
                                    color: isSelected 
                                      ? app.primaryColor
                                      : themeProvider.currentTheme.colorScheme.onSurface,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                
                                const SizedBox(height: 4),
                                
                                // UI Kit Type
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                      ? app.primaryColor.withOpacity(0.2)
                                      : themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    app.uiKitType.toUpperCase(),
                                    style: themeProvider.currentTheme.textTheme.labelSmall?.copyWith(
                                      color: isSelected 
                                        ? app.primaryColor
                                        : themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.6),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 9,
                                      letterSpacing: 0.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                
                                const SizedBox(height: 8),
                                
                                // Pages Count
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.widgets_outlined,
                                      size: 12,
                                      color: themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.5),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${app.pages.length} ${isArabic ? 'صفحات' : 'pages'}',
                                      style: themeProvider.currentTheme.textTheme.labelSmall?.copyWith(
                                        color: themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.5),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Footer
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Divider(
                      color: themeProvider.currentTheme.dividerColor.withOpacity(0.1),
                      height: 1,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.palette_outlined,
                          size: 16,
                          color: themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isArabic 
                              ? 'مجموعة شاملة من أنماط واجهات المستخدم'
                              : 'Complete UI Kit Collection',
                            style: themeProvider.currentTheme.textTheme.labelSmall?.copyWith(
                              color: themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
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
