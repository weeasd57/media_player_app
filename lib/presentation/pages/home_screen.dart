import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import '../providers/media_provider.dart';
import '../providers/theme_provider.dart';
import '../../generated/app_localizations.dart';
import '../../data/models/media_file.dart';
import 'audio_player_screen.dart';
import 'video_player_screen.dart';
import 'favorites_screen.dart';
import 'recent_played_screen.dart';
import '../../widgets/neumorphic_components.dart' as neumorphic;

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;
  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _statsAnimationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _statsAnimation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _statsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _statsAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _statsAnimationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );
  }

  Future<void> _initializeApp() async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    await mediaProvider.initialize();

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });

      _headerAnimationController.forward();
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        _statsAnimationController.forward();
      }
    }
  }

  /// Navigate to specific section based on index
  /// 0: Audio Files, 1: Video Files, 2: Favorites, 3: Playlists
  void _navigateToSection(int index) {
    if (widget.onNavigateToTab != null) {
      if (index == 2) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FavoritesScreen(),
          ),
        );
      } else {
        widget.onNavigateToTab!(index);
      }
    }
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _statsAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer2<MediaProvider, ThemeProvider>(
      builder: (context, mediaProvider, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
          body: _isInitialized
              ? _buildMainContent(themeProvider, l10n)
              : _buildLoadingScreen(themeProvider, l10n),
        );
      },
    );
  }

  Widget _buildLoadingScreen(
    ThemeProvider themeProvider,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            l10n.settingUpLibrary,
            style: TextStyle(
              color: themeProvider.currentTheme.colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
    ThemeProvider themeProvider,
    AppLocalizations l10n,
  ) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          _buildHeader(themeProvider, l10n),
          _buildStatsSection(themeProvider, l10n),
          _buildRecentSection(themeProvider, l10n),
          _buildNowPlayingSection(themeProvider, l10n),
          _buildFavoritesSection(themeProvider, l10n),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeProvider themeProvider, AppLocalizations l10n) {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _headerAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - _headerAnimation.value)),
            child: Opacity(
              opacity: _headerAnimation.value.clamp(0.0, 1.0),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Row(
                      children: [
                        // App Logo with enhanced design
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                themeProvider.currentTheme.colorScheme.primary,
                                themeProvider.currentTheme.colorScheme.secondary,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: themeProvider.currentTheme.colorScheme.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/icons/app_icon.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback icon if image fails to load
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        themeProvider.currentTheme.colorScheme.primary,
                                        themeProvider.currentTheme.colorScheme.secondary,
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.music_note_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getTimeOfDay(l10n),
                                style: TextStyle(
                                  color: themeProvider.currentTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                l10n.appName,
                                style: TextStyle(
                                  color: themeProvider.currentTheme.colorScheme.onSurface,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        neumorphic.NeumorphicButton(
                          icon: Icons.search,
                          onTap: _showSearchDialog,
                          size: 40,
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
    );
  }

  Widget _buildStatsSection(
    ThemeProvider themeProvider,
    AppLocalizations l10n,
  ) {
    return SliverToBoxAdapter(
      child: Consumer<MediaProvider>(
        builder: (context, mediaProvider, child) {
          final stats = mediaProvider.statistics;

          return AnimatedBuilder(
            animation: _statsAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _statsAnimation.value.clamp(0.0, 1.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width < 600 ? 16 : 24,
                    vertical: 8,
                  ),
                  child: neumorphic.NeumorphicCard(
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width < 600 ? 16 : 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.yourLibrary,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.currentTheme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                title: l10n.audioFiles,
                                count: stats['audio'] ?? 0,
                                icon: Icons.headphones,
                                accentColor: Colors.purple.shade300,
                                index: 0,
                                themeProvider: themeProvider,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                title: l10n.videoFiles,
                                count: stats['video'] ?? 0,
                                icon: Icons.movie_creation_outlined,
                                accentColor: Colors.orange.shade300,
                                index: 1,
                                themeProvider: themeProvider,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                title: l10n.favorites,
                                count: stats['favorites'] ?? 0,
                                icon: Icons.favorite,
                                accentColor: Colors.red.shade300,
                                index: 2,
                                themeProvider: themeProvider,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                title: l10n.playlists,
                                count: stats['playlists'] ?? 0,
                                icon: Icons.queue_music,
                                accentColor: Colors.indigo.shade300,
                                index: 3,
                                themeProvider: themeProvider,
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
          );
        },
      ),
    );
  }

  /// Enhanced stat card with navigation functionality
  Widget _buildStatCard({
    required String title,
    required int count,
    required IconData icon,
    required Color accentColor,
    required int index,
    required ThemeProvider themeProvider,
  }) {
    return GestureDetector(
      onTap: () => _navigateToSection(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: neumorphic.NeumorphicContainer(
          padding: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(16),
          isInset: true,
          child: Column(
            children: [
              // Icon with subtle animation on tap
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 150),
                tween: Tween(begin: 1.0, end: 1.0),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Icon(icon, color: accentColor, size: 32),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: themeProvider.currentTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSection(
    ThemeProvider themeProvider,
    AppLocalizations l10n,
  ) {
    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        if (mediaProvider.recentFiles.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.recentlyPlayed,
                      style: TextStyle(
                        color: themeProvider.currentTheme.colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RecentPlayedScreen(),
                          ),
                        );
                      },
                      child: Text(
                        l10n.seeAll,
                        style: TextStyle(
                          color: themeProvider.currentTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: MediaQuery.of(context).size.width < 600 ? 120 : 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: mediaProvider.recentFiles.length,
                  itemBuilder: (context, index) {
                    final file = mediaProvider.recentFiles[index];
                    return _buildMediaCard(file, index, themeProvider);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNowPlayingSection(
    ThemeProvider themeProvider,
    AppLocalizations l10n,
  ) {
    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        final currentMedia = mediaProvider.currentMediaFile;
        final lastPlayedMedia = mediaProvider.recentFiles.isNotEmpty 
            ? mediaProvider.recentFiles.first 
            : null;
        
        // تحديد الوسائط المراد عرضها (الحالية أو الأخيرة)
        final displayMedia = currentMedia ?? lastPlayedMedia;
        
        // تحديد العنوان والرمز بناء على الحالة
        final sectionTitle = currentMedia != null 
            ? l10n.nowPlaying
            : lastPlayedMedia != null 
                ? l10n.recentlyPlayed
                : l10n.nowPlaying;
        
        final displayText = displayMedia?.name ?? l10n.noFilePlaying;
        final actionIcon = displayMedia != null ? Icons.play_arrow : Icons.library_music;
        
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: neumorphic.NeumorphicCard(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () => _handleNowPlayingTap(displayMedia),
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sectionTitle,
                            style: TextStyle(
                            color: themeProvider.currentTheme.colorScheme.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            displayText,
                            style: TextStyle(
                              color: themeProvider.currentTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (displayMedia != null && currentMedia == null) ...[
                            const SizedBox(height: 4),
                            Text(
                              l10n.playAll,
                              style: TextStyle(
                                color: themeProvider.currentTheme.colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: themeProvider.currentTheme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        actionIcon,
                        color: themeProvider.currentTheme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  void _handleNowPlayingTap(dynamic displayMedia) {
    if (displayMedia != null) {
      // تحديث الوسائط الحالية في المزود
      final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
      mediaProvider.setCurrentMediaFile(displayMedia);
      
      // انتقل إلى مشغل الوسائط المناسب
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              displayMedia.type == 'audio'
                  ? const AudioPlayerScreen()
                  : const VideoPlayerScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    } else {
      // إذا لم يكن هناك ملف، انتقل إلى صفحة المكتبة
      if (widget.onNavigateToTab != null) {
        widget.onNavigateToTab!(1); // Library tab index
      }
    }
  }

  Widget _buildFavoritesSection(
    ThemeProvider themeProvider,
    AppLocalizations l10n,
  ) {
    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        if (mediaProvider.favoriteFiles.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.yourFavorites,
                      style: TextStyle(
                        color: themeProvider.currentTheme.colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const FavoritesScreen(),
                          ),
                        );
                      },
                      child: Text(
                        l10n.seeAll,
                        style: TextStyle(
                          color: themeProvider.currentTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: MediaQuery.of(context).size.width < 600 ? 120 : 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width < 600
                        ? 16
                        : 24,
                  ),
                  itemCount: mediaProvider.favoriteFiles.length,
                  itemBuilder: (context, index) {
                    final file = mediaProvider.favoriteFiles[index];
                    return _buildMediaCard(file, index, themeProvider);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMediaCard(
    MediaFile file,
    int index,
    ThemeProvider themeProvider,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 600 ? 120.0 : 150.0;
    final textColor = themeProvider.currentTheme.colorScheme.onSurface;
    final cardBgColor = themeProvider.currentTheme.cardColor;
    final borderColor = themeProvider.currentTheme.dividerColor;

    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(right: screenWidth < 600 ? 12 : 16),
      child: OpenContainer(
        transitionDuration: const Duration(milliseconds: 500),
        closedElevation: 0,
        openElevation: 0,
        middleColor: Colors.transparent,
        closedColor: Colors.transparent,
        openColor: Colors.transparent,
        useRootNavigator: false,
        routeSettings: RouteSettings(name: 'media_${file.path}_$index'),
        openBuilder: (context, action) => file.type == 'audio'
            ? const AudioPlayerScreen()
            : const VideoPlayerScreen(),
        closedBuilder: (context, action) => Container(
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: file.type == 'audio'
                        ? themeProvider.currentTheme.colorScheme.primary
                              .withValues(alpha: 0.3)
                        : themeProvider.currentTheme.colorScheme.secondary
                              .withValues(alpha: 0.3),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      file.type == 'audio'
                          ? Icons.graphic_eq
                          : Icons.movie_filter,
                      size: 40,
                      color: themeProvider.currentTheme.iconTheme.color,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      file.name,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      file.formattedDuration,
                      style: TextStyle(
                        color: themeProvider.currentTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 10,
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
  }

  String _getTimeOfDay(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  void _showSearchDialog() {
    showDialog(context: context, builder: (context) => const _SearchDialog());
  }
}

class _SearchDialog extends StatefulWidget {
  const _SearchDialog();

  @override
  State<_SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<_SearchDialog> {
  final _controller = TextEditingController();
  List<MediaFile> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: isSmallScreen ? screenSize.width * 0.9 : 500,
        height: isSmallScreen ? screenSize.height * 0.7 : 500,
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: l10n.search,
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _performSearch,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                  ? Center(
                      child: Text(
                        l10n.noFilesFound,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final file = _searchResults[index];
                        return ListTile(
                          leading: Icon(
                            file.type == 'audio'
                                ? Icons.music_note_rounded
                                : Icons.video_library_rounded,
                          ),
                          title: Text(file.name),
                          subtitle: Text(file.formattedDuration),
                          onTap: () {
                            Navigator.of(context).pop();
                            // Play the selected file
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch(String query) async {
    if (query.isEmpty) {
      if (!mounted) return;
      setState(() {
        _searchResults = [];
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _isSearching = true;
    });

    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    final results = await mediaProvider.searchMediaFiles(query);

    if (!mounted) return;
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }
}