import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../utils/responsive_layout.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppProvider, ThemeProvider, LocaleProvider>(
      builder: (context, appProvider, themeProvider, localeProvider, child) {
        final isArabic = localeProvider.locale.languageCode == 'ar';
        // بما أن لدينا حالتين فقط، لا حاجة إلى حالة الطي
        // final isCollapsed = appProvider.isSidebarCollapsed;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          width: ResponsiveLayout.getSidebarWidth(context), // عرض responsive
          decoration: BoxDecoration(
            color: themeProvider.currentTheme.colorScheme.surface,
            border: Border(
              right: BorderSide(
                color: themeProvider.currentTheme.dividerColor.withAlpha(
                  (0.1 * 255).round(),
                ),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.05 * 255).round()),
                blurRadius: 20,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Toggle button - وضع حجم محدد للزر
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: ResponsiveLayout.getNavigationIconSize(context),
                  onPressed: () {
                    debugPrint("DEBUG: Toggle sidebar button pressed");
                    appProvider.toggleSidebar();
                    // Show visual feedback to confirm click
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          appProvider.isSidebarHidden
                              ? 'تم إخفاء القائمة'
                              : 'تم إظهار القائمة',
                        ),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  tooltip: appProvider.isSidebarHidden
                      ? 'فتح القائمة الجانبية'
                      : 'إخفاء القائمة الجانبية',
                  icon: Icon(
                    appProvider.isSidebarHidden
                        ? (isArabic ? Icons.chevron_left : Icons.chevron_right)
                        : (isArabic ? Icons.chevron_right : Icons.chevron_left),
                    color: themeProvider.currentTheme.colorScheme.primary,
                  ),
                ),
              ),
              // Apps Grid
              Expanded(
                child: Padding(
                  padding: ResponsiveLayout.getPadding(context),
                  child: GridView.builder(
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveLayout.getSidebarGridColumns(context),
                          mainAxisSpacing: ResponsiveLayout.getValue(context, mobile: 8, tablet: 12, desktop: 16),
                          crossAxisSpacing: ResponsiveLayout.getValue(context, mobile: 8, tablet: 12, desktop: 16),
                          childAspectRatio: ResponsiveLayout.getValue(context, mobile: 1.1, tablet: 1.3, desktop: 1.4),
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
                                ? app.primaryColor.withAlpha(
                                    (0.1 * 255).round(),
                                  )
                                : themeProvider
                                      .currentTheme
                                      .colorScheme
                                      .surfaceContainerHighest
                                      .withAlpha((0.3 * 255).round()),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? app.primaryColor.withAlpha(
                                      (0.5 * 255).round(),
                                    )
                                  : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: app.primaryColor.withAlpha(
                                        (0.2 * 255).round(),
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              12,
                            ), // تقليل المساحة الداخلية
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize:
                                  MainAxisSize.min, // تقليل الحجم للأدنى
                              children: [
                                // App Icon
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: ResponsiveLayout.getSidebarCardIconSize(context, isSelected),
                                  height: ResponsiveLayout.getSidebarCardIconSize(context, isSelected),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        app.primaryColor,
                                        app.secondaryColor,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: app.primaryColor.withAlpha(
                                          ((isSelected ? 0.4 : 0.2) * 255)
                                              .round(),
                                        ),
                                        blurRadius: (isSelected ? 16 : 8)
                                            .toDouble(),
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Icon(
                                      app.icon,
                                      color: Colors.white,
                                      size: ResponsiveLayout.getSidebarCardIconSize(context, isSelected) * 0.6,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8), // تقليل المسافة
                                // App Name
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    isArabic ? app.nameAr : app.name,
                                    style: themeProvider
                                        .currentTheme
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: isSelected
                                              ? app.primaryColor
                                              : themeProvider
                                                    .currentTheme
                                                    .colorScheme
                                                    .onSurface,
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w600,
                                          fontSize: ResponsiveLayout.getValue(
                                            context,
                                            mobile: ResponsiveLayout.isSmallMobile(context) ? 11 : 12,
                                            tablet: 13,
                                            desktop: 14,
                                          ),
                                        ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                const SizedBox(height: 2), // تقليل المسافة
                                // UI Kit Type
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? app.primaryColor.withAlpha(
                                            (0.2 * 255).round(),
                                          )
                                        : themeProvider
                                              .currentTheme
                                              .colorScheme
                                              .onSurface
                                              .withAlpha((0.1 * 255).round()),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      app.uiKitType.toUpperCase(),
                                      style: themeProvider
                                          .currentTheme
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: isSelected
                                                ? app.primaryColor
                                                : themeProvider
                                                      .currentTheme
                                                      .colorScheme
                                                      .onSurface
                                                      .withAlpha(
                                                        (0.6 * 255).round(),
                                                      ),
                                            fontWeight: FontWeight.w600,
                                            fontSize: ResponsiveLayout.getValue(
                                              context,
                                              mobile: ResponsiveLayout.isSmallMobile(context) ? 8 : 9,
                                              tablet: 10,
                                              desktop: 11,
                                            ),
                                            letterSpacing: 0.5,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 4), // تقليل المسافة
                                // Pages Count
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.widgets_outlined,
                                        size: ResponsiveLayout.getValue(
                                          context,
                                          mobile: ResponsiveLayout.isSmallMobile(context) ? 10 : 12,
                                          tablet: 13,
                                          desktop: 14,
                                        ),
                                        color: themeProvider
                                            .currentTheme
                                            .colorScheme
                                            .onSurface
                                            .withAlpha((0.5 * 255).round()),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${app.pages.length} ${isArabic ? 'صفحات' : 'pages'}',
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
                                              fontSize: ResponsiveLayout.getValue(
                                                context,
                                                mobile: ResponsiveLayout.isSmallMobile(context) ? 9 : 10,
                                                tablet: 11,
                                                desktop: 12,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
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
                padding: ResponsiveLayout.getPadding(context),
                child: Column(
                  children: [
                    Divider(
                      color: themeProvider.currentTheme.dividerColor.withAlpha(
                        (0.1 * 255).round(),
                      ),
                      height: 1,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Icon(
                            Icons.palette_outlined,
                            size: ResponsiveLayout.getSmallIconSize(context),
                            color: themeProvider
                                .currentTheme
                                .colorScheme
                                .onSurface
                                .withAlpha((0.6 * 255).round()),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              isArabic
                                  ? 'مجموعة شاملة من أنماط واجهات المستخدم'
                                  : 'Complete UI Kit Collection',
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
                                    fontSize: ResponsiveLayout.getValue(
                                      context,
                                      mobile: ResponsiveLayout.isSmallMobile(context) ? 10 : 11,
                                      tablet: 12,
                                      desktop: 13,
                                    ),
                                  ),
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
