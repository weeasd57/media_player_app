import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import '../providers/media_provider.dart';
import '../models/media_file.dart';
import '../models/playlist.dart';
import 'package:media_player_app/generated/app_localizations.dart';
import 'audio_player_screen.dart';
import 'video_player_screen.dart';
import 'playlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _statsAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        return Scaffold(
          body: _isInitialized ? _buildMainContent() : _buildLoadingScreen(),
        );
      },
    );
  }

  Widget _buildLoadingScreen() {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            localizations.loadingLibrary,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          _buildHeader(),
          _buildStatsSection(),
          _buildQuickActions(),
          _buildRecentSection(),
          _buildFavoritesSection(),
          _buildPlaylistsSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final iconBgColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.grey.withValues(alpha: 0.1);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

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
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: iconBgColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.graphic_eq,
                            color: Theme.of(context).primaryColor,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getTimeOfDay(),
                                style: TextStyle(
                                  color: textColor.withValues(alpha: 0.7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                localizations.appTitle,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _showSearchDialog,
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: iconBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.search, color: textColor),
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
    );
  }

  Widget _buildStatsSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final cardBgColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.grey.withValues(alpha: 0.05);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.grey.withValues(alpha: 0.2);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return SliverToBoxAdapter(
      child: Consumer<MediaProvider>(
        builder: (context, mediaProvider, child) {
          final stats = mediaProvider.statistics;

          return AnimatedBuilder(
            animation: _statsAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _statsAnimation.value.clamp(0.0, 1.0),
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width < 600
                        ? 16
                        : 24,
                  ),
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width < 600 ? 16 : 20,
                  ),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.yourLibrary,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              localizations.audioFiles,
                              stats['audio'] ?? 0,
                              Icons.headphones,
                              Colors.purple,
                              0,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              localizations.videoFiles,
                              stats['video'] ?? 0,
                              Icons.movie_creation_outlined,
                              Colors.orange,
                              1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              localizations.favorites,
                              stats['favorites'] ?? 0,
                              Icons.favorite,
                              Colors.red,
                              2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              localizations.playlists,
                              stats['playlists'] ?? 0,
                              Icons.queue_music,
                              Colors.indigo,
                              3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    int count,
    IconData icon,
    Color color,
    int index,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(
          MediaQuery.of(context).size.width < 600 ? 16 : 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.quickActions,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    localizations.scanFiles,
                    Icons.sync,
                    Colors.blue,
                    () => _scanForFiles(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    localizations.createPlaylist,
                    Icons.playlist_add,
                    Colors.green,
                    () => _createPlaylist(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final cardBgColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.grey.withValues(alpha: 0.05);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.grey.withValues(alpha: 0.2);

    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 500),
      openBuilder: (context, action) => Container(), // Placeholder
      closedBuilder: (context, action) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSection() {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

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
                child: Text(
                  localizations.recentlyPlayed,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
                    return _buildMediaCard(file, index);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFavoritesSection() {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

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
                child: Text(
                  localizations.yourFavorites,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
                    return _buildMediaCard(file, index);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaylistsSection() {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        if (mediaProvider.playlists.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox(height: 100));
        }

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Text(
                  localizations.yourPlaylists,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: mediaProvider.playlists.length,
                itemBuilder: (context, index) {
                  final playlist = mediaProvider.playlists[index];
                  return _buildPlaylistCard(playlist);
                },
              ),
              const SizedBox(height: 100), // Bottom padding for FAB
            ],
          ),
        );
      },
    );
  }

  Widget _buildMediaCard(MediaFile file, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 600 ? 120.0 : 150.0;

    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(right: screenWidth < 600 ? 12 : 16),
      child: OpenContainer(
        transitionDuration: const Duration(milliseconds: 500),
        openBuilder: (context, action) => file.type == 'audio'
            ? const AudioPlayerScreen()
            : const VideoPlayerScreen(),
        closedBuilder: (context, action) => Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: file.type == 'audio'
                        ? Colors.purple.withValues(alpha: 0.3)
                        : Colors.orange.withValues(alpha: 0.3),
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
                      color: Colors.white,
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
                      style: const TextStyle(
                        color: Colors.white,
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
                        color: Colors.white.withValues(alpha: 0.7),
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

  Widget _buildPlaylistCard(Playlist playlist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: OpenContainer(
        transitionDuration: const Duration(milliseconds: 500),
        openBuilder: (context, action) => PlaylistScreen(playlist: playlist),
        closedBuilder: (context, action) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.library_music,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.filesCount(playlist.mediaCount),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withValues(alpha: 0.7),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeOfDay() {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final hour = DateTime.now().hour;
    if (hour < 12) return localizations.goodMorning;
    if (hour < 17) return localizations.goodAfternoon;
    return localizations.goodEvening;
  }

  void _showSearchDialog() {
    showDialog(context: context, builder: (context) => const _SearchDialog());
  }

  void _scanForFiles() async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    await mediaProvider.scanForMediaFiles();
  }

  void _createPlaylist() async {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _CreatePlaylistDialog(localizations: localizations),
    );

    if (result != null && result.isNotEmpty) {
      final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
      await mediaProvider.createPlaylist(result);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.playlistCreated),
          backgroundColor: Colors.green,
        ),
      );
    }
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
    final AppLocalizations localizations = AppLocalizations.of(context)!;

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
                labelText: localizations.searchMediaFiles,
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
                        localizations.noMediaFound,
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

class _CreatePlaylistDialog extends StatefulWidget {
  final AppLocalizations localizations;
  const _CreatePlaylistDialog({required this.localizations});

  @override
  State<_CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<_CreatePlaylistDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      title: Text(
        widget.localizations.createNewPlaylist,
        style: TextStyle(
          fontSize: isSmallScreen ? 18 : 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: isSmallScreen ? screenSize.width * 0.8 : 300,
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.localizations.playlistName,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          autofocus: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.localizations.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(widget.localizations.create),
        ),
      ],
    );
  }
}
