import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/app_provider.dart';
import '../widgets/themed_card.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, LocaleProvider, AppProvider>(
      builder: (context, themeProvider, localeProvider, appProvider, child) {
        final isArabic = localeProvider.locale.languageCode == 'ar';
        final currentApp = appProvider.currentApp;

        return Scaffold(
          backgroundColor: themeProvider.currentTheme.colorScheme.surface,
          body: _buildResponsiveLayout(
            context,
            themeProvider,
            isArabic,
            currentApp,
          ),
        );
      },
    );
  }

  Widget _buildResponsiveLayout(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isArabic,
    currentApp,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return _buildDesktopLayout(
            context,
            themeProvider,
            isArabic,
            currentApp,
          );
        } else if (constraints.maxWidth > 800) {
          return _buildTabletLayout(
            context,
            themeProvider,
            isArabic,
            currentApp,
          );
        } else {
          return _buildMobileLayout(
            context,
            themeProvider,
            isArabic,
            currentApp,
          );
        }
      },
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isArabic,
    currentApp,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(context, themeProvider, isArabic, currentApp),
          const SizedBox(height: 24),
          _buildNowPlaying(context, themeProvider, isArabic, currentApp),
          const SizedBox(height: 24),
          _buildQuickActions(context, themeProvider, isArabic, currentApp),
          const SizedBox(height: 24),
          _buildRecentTracks(context, themeProvider, isArabic, currentApp),
          const SizedBox(height: 24),
          _buildPlaylists(context, themeProvider, isArabic, currentApp),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isArabic,
    currentApp,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(context, themeProvider, isArabic, currentApp),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildNowPlaying(
                      context,
                      themeProvider,
                      isArabic,
                      currentApp,
                    ),
                    const SizedBox(height: 24),
                    _buildRecentTracks(
                      context,
                      themeProvider,
                      isArabic,
                      currentApp,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildQuickActions(
                      context,
                      themeProvider,
                      isArabic,
                      currentApp,
                    ),
                    const SizedBox(height: 24),
                    _buildPlaylists(
                      context,
                      themeProvider,
                      isArabic,
                      currentApp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isArabic,
    currentApp,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(context, themeProvider, isArabic, currentApp),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildNowPlaying(
                      context,
                      themeProvider,
                      isArabic,
                      currentApp,
                    ),
                    const SizedBox(height: 24),
                    _buildRecentTracks(
                      context,
                      themeProvider,
                      isArabic,
                      currentApp,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildQuickActions(
                      context,
                      themeProvider,
                      isArabic,
                      currentApp,
                    ),
                    const SizedBox(height: 24),
                    _buildPlaylists(
                      context,
                      themeProvider,
                      isArabic,
                      currentApp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isArabic,
    currentApp,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'مرحباً بك في مشغل الوسائط' : 'Welcome to Media Player',
          style: themeProvider.currentTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: currentApp.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isArabic
              ? 'استمتع بموسيقاك المفضلة ومقاطع الفيديو'
              : 'Enjoy your favorite music and videos',
          style: themeProvider.currentTheme.textTheme.bodyLarge?.copyWith(
            color: themeProvider.currentTheme.colorScheme.onSurface.withAlpha(
              (0.7 * 255).round(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNowPlaying(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isArabic,
    currentApp,
  ) {
    return ThemedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.music_note, color: currentApp.primaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'الآن يتم التشغيل' : 'Now Playing',
                style: themeProvider.currentTheme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  currentApp.primaryColor.withOpacity(0.1),
                  currentApp.secondaryColor.withOpacity(0.1),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: currentApp.primaryColor.withOpacity(0.2),
                  ),
                  child: Icon(
                    Icons.music_note,
                    color: currentApp.primaryColor,
                    size: 40,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isArabic ? 'اسم الأغنية' : 'Song Title',
                          style: themeProvider
                              .currentTheme
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isArabic ? 'اسم الفنان' : 'Artist Name',
                          style: themeProvider.currentTheme.textTheme.bodyMedium
                              ?.copyWith(
                                color: themeProvider
                                    .currentTheme
                                    .colorScheme
                                    .onSurface
                                    .withAlpha((0.7 * 255).round()),
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.play_circle_filled,
                              color: currentApp.primaryColor,
                              size: 32,
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.skip_previous,
                              color: currentApp.primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.skip_next,
                              color: currentApp.primaryColor,
                              size: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isArabic,
    currentApp,
  ) {
    return ThemedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'إجراءات سريعة' : 'Quick Actions',
            style: themeProvider.currentTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildActionCard(
                context,
                themeProvider,
                isArabic,
                currentApp,
                Icons.library_music,
                isArabic ? 'المكتبة' : 'Library',
                () => onNavigateToTab?.call(1),
              ),
              _buildActionCard(
                context,
                themeProvider,
                isArabic,
                currentApp,
                Icons.headphones,
                isArabic ? 'الصوت' : 'Audio',
                () => onNavigateToTab?.call(2),
              ),
              _buildActionCard(
                context,
                themeProvider,
                isArabic,
                currentApp,
                Icons.video_library,
                isArabic ? 'الفيديو' : 'Video',
                () => onNavigateToTab?.call(3),
              ),
              _buildActionCard(
                context,
                themeProvider,
                isArabic,
                currentApp,
                Icons.equalizer,
                isArabic ? 'المعادل' : 'Equalizer',
                () => onNavigateToTab?.call(4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isArabic,
    currentApp,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: currentApp.primaryColor.withOpacity(0.1),
          border: Border.all(color: currentApp.primaryColor.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: currentApp.primaryColor, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: themeProvider.currentTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTracks(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isArabic,
    currentApp,
  ) {
    return ThemedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'الأغاني الحديثة' : 'Recent Tracks',
            style: themeProvider.currentTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: currentApp.primaryColor.withOpacity(0.1),
                  ),
                  child: Icon(Icons.music_note, color: currentApp.primaryColor),
                ),
                title: Text(
                  isArabic ? 'أغنية ${index + 1}' : 'Track ${index + 1}',
                  style: themeProvider.currentTheme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  isArabic ? 'فنان ${index + 1}' : 'Artist ${index + 1}',
                  style: themeProvider.currentTheme.textTheme.bodySmall
                      ?.copyWith(
                        color: themeProvider.currentTheme.colorScheme.onSurface
                            .withAlpha((0.7 * 255).round()),
                      ),
                ),
                trailing: Icon(
                  Icons.play_circle_outline,
                  color: currentApp.primaryColor,
                ),
                onTap: () {
                  // Play track
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylists(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isArabic,
    currentApp,
  ) {
    return ThemedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'قوائم التشغيل' : 'Playlists',
            style: themeProvider.currentTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              final playlistNames = isArabic
                  ? ['المفضلة', 'الاسترخاء', 'الطاقة']
                  : ['Favorites', 'Relax', 'Energy'];

              return ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [
                        currentApp.primaryColor,
                        currentApp.secondaryColor,
                      ],
                    ),
                  ),
                  child: Icon(Icons.playlist_play, color: Colors.white),
                ),
                title: Text(
                  playlistNames[index],
                  style: themeProvider.currentTheme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${(index + 1) * 5} ${isArabic ? 'أغنية' : 'tracks'}',
                  style: themeProvider.currentTheme.textTheme.bodySmall
                      ?.copyWith(
                        color: themeProvider.currentTheme.colorScheme.onSurface
                            .withAlpha((0.7 * 255).round()),
                      ),
                ),
                onTap: () {
                  // Open playlist
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
