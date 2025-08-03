import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/app_provider.dart';
import '../widgets/themed_card.dart';
import '../widgets/themed_button.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigateToTab;

  const HomeScreen({
    super.key,
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, LocaleProvider, AppProvider>(
      builder: (context, themeProvider, localeProvider, appProvider, child) {
        final isArabic = localeProvider.locale.languageCode == 'ar';
        final currentApp = appProvider.currentApp;
        
        return Scaffold(
          backgroundColor: themeProvider.currentTheme.colorScheme.surface,
          body: _buildResponsiveLayout(context, themeProvider, isArabic, currentApp),
        );
      },
    );
  }

  Widget _buildResponsiveLayout(BuildContext context, ThemeProvider themeProvider, bool isArabic, currentApp) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          // Desktop Layout
          return _buildDesktopLayout(context, themeProvider, isArabic, currentApp);
        } else if (constraints.maxWidth > 800) {
          // Tablet Layout
          return _buildTabletLayout(context, themeProvider, isArabic, currentApp);
        } else {
          // Mobile Layout
          return _buildMobileLayout(context, themeProvider, isArabic, currentApp);
        }
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ThemeProvider themeProvider, bool isArabic, currentApp) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, themeProvider, isArabic, currentApp),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildQuickStats(context, themeProvider, isArabic, currentApp),
                    const SizedBox(height: 24),
                    _buildRecentActivity(context, themeProvider, isArabic, currentApp),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildQuickActions(context, themeProvider, isArabic, currentApp),
                    const SizedBox(height: 24),
                    _buildFeatures(context, themeProvider, isArabic, currentApp),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, ThemeProvider themeProvider, bool isArabic, currentApp) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, themeProvider, isArabic, currentApp),
          const SizedBox(height: 24),
          _buildQuickStats(context, themeProvider, isArabic, currentApp),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildRecentActivity(context, themeProvider, isArabic, currentApp),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildQuickActions(context, themeProvider, isArabic, currentApp),
                    const SizedBox(height: 24),
                    _buildFeatures(context, themeProvider, isArabic, currentApp),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, ThemeProvider themeProvider, bool isArabic, currentApp) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, themeProvider, isArabic, currentApp),
          const SizedBox(height: 20),
          _buildQuickStats(context, themeProvider, isArabic, currentApp),
          const SizedBox(height: 20),
          _buildQuickActions(context, themeProvider, isArabic, currentApp),
          const SizedBox(height: 20),
          _buildRecentActivity(context, themeProvider, isArabic, currentApp),
          const SizedBox(height: 20),
          _buildFeatures(context, themeProvider, isArabic, currentApp),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeProvider themeProvider, bool isArabic, currentApp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic 
            ? 'مرحباً بك في ${currentApp.nameAr}'
            : 'Welcome to ${currentApp.name}',
          style: themeProvider.currentTheme.textTheme.headlineMedium?.copyWith(
            color: themeProvider.currentTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isArabic
            ? 'استكشف إمكانيات لا محدودة مع مجموعة ${currentApp.uiKitType.toUpperCase()} UI Kit'
            : 'Explore limitless possibilities with ${currentApp.uiKitType.toUpperCase()} UI Kit collection',
          style: themeProvider.currentTheme.textTheme.bodyLarge?.copyWith(
            color: themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, ThemeProvider themeProvider, bool isArabic, currentApp) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isMobile ? 2 : 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: isMobile ? 1.2 : 1.5,
          children: [
            _buildStatCard(
              context,
              themeProvider,
              isArabic,
              currentApp,
              Icons.play_circle_outline,
              '2,847',
              isArabic ? 'مشاهدات' : 'Plays',
            ),
            _buildStatCard(
              context,
              themeProvider,
              isArabic,
              currentApp,
              Icons.favorite_outline,
              '1,234',
              isArabic ? 'إعجابات' : 'Likes',
            ),
            _buildStatCard(
              context,
              themeProvider,
              isArabic,
              currentApp,
              Icons.library_music_outlined,
              '567',
              isArabic ? 'قوائم تشغيل' : 'Playlists',
            ),
            _buildStatCard(
              context,
              themeProvider,
              isArabic,
              currentApp,
              Icons.people_outline,
              '89',
              isArabic ? 'متابعين' : 'Followers',
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, ThemeProvider themeProvider, bool isArabic, currentApp, IconData icon, String value, String label) {
    return ThemedCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: currentApp.primaryColor,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: themeProvider.currentTheme.textTheme.headlineSmall?.copyWith(
              color: themeProvider.currentTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: themeProvider.currentTheme.textTheme.bodySmall?.copyWith(
              color: themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ThemeProvider themeProvider, bool isArabic, currentApp) {
    return ThemedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.flash_on,
                color: currentApp.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'إجراءات سريعة' : 'Quick Actions',
                style: themeProvider.currentTheme.textTheme.titleLarge?.copyWith(
                  color: themeProvider.currentTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              ThemedButton(
                text: isArabic ? 'إنشاء قائمة جديدة' : 'Create New Playlist',
                icon: Icons.add_circle_outline,
                width: double.infinity,
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              ThemedButton(
                text: isArabic ? 'تصفح المكتبة' : 'Browse Library',
                icon: Icons.library_music_outlined,
                width: double.infinity,
                isOutlined: true,
                onPressed: () => onNavigateToTab(1),
              ),
              const SizedBox(height: 12),
              ThemedButton(
                text: isArabic ? 'المفضلة' : 'Favorites',
                icon: Icons.favorite_outline,
                width: double.infinity,
                isOutlined: true,
                onPressed: () => onNavigateToTab(2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, ThemeProvider themeProvider, bool isArabic, currentApp) {
    final activities = [
      {
        'title': isArabic ? 'أغنية جميلة' : 'Beautiful Song',
        'subtitle': isArabic ? 'تم تشغيلها منذ ساعتين' : 'Played 2 hours ago',
        'icon': Icons.music_note,
      },
      {
        'title': isArabic ? 'قائمة تشغيل المفضلة' : 'Favorite Playlist',
        'subtitle': isArabic ? 'تم إنشاؤها أمس' : 'Created yesterday',
        'icon': Icons.playlist_play,
      },
      {
        'title': isArabic ? 'فيديو رائع' : 'Amazing Video',
        'subtitle': isArabic ? 'تم مشاهدته منذ 3 أيام' : 'Watched 3 days ago',
        'icon': Icons.videocam,
      },
    ];

    return ThemedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: currentApp.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'النشاط الأخير' : 'Recent Activity',
                style: themeProvider.currentTheme.textTheme.titleLarge?.copyWith(
                  color: themeProvider.currentTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...activities.map((activity) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: currentApp.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    activity['icon'] as IconData,
                    color: currentApp.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['title'] as String,
                        style: themeProvider.currentTheme.textTheme.bodyLarge?.copyWith(
                          color: themeProvider.currentTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        activity['subtitle'] as String,
                        style: themeProvider.currentTheme.textTheme.bodySmall?.copyWith(
                          color: themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildFeatures(BuildContext context, ThemeProvider themeProvider, bool isArabic, currentApp) {
    final features = [
      {
        'title': isArabic ? 'واجهة حديثة' : 'Modern Interface',
        'description': isArabic ? 'تصميم عصري وأنيق' : 'Sleek and modern design',
        'icon': Icons.auto_awesome,
      },
      {
        'title': isArabic ? 'تجربة سلسة' : 'Smooth Experience',
        'description': isArabic ? 'أداء متميز وسريع' : 'Outstanding and fast performance',
        'icon': Icons.speed,
      },
      {
        'title': isArabic ? 'سهولة الاستخدام' : 'Easy to Use',
        'description': isArabic ? 'واجهة بديهية ومفهومة' : 'Intuitive and understandable interface',
        'icon': Icons.touch_app,
      },
    ];

    return ThemedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star_outline,
                color: currentApp.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'المميزات' : 'Features',
                style: themeProvider.currentTheme.textTheme.titleLarge?.copyWith(
                  color: themeProvider.currentTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: currentApp.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    feature['icon'] as IconData,
                    color: currentApp.primaryColor,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature['title'] as String,
                        style: themeProvider.currentTheme.textTheme.bodyLarge?.copyWith(
                          color: themeProvider.currentTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        feature['description'] as String,
                        style: themeProvider.currentTheme.textTheme.bodySmall?.copyWith(
                          color: themeProvider.currentTheme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}
