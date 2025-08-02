import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/media_provider.dart';
import '../providers/theme_provider.dart';
import '../../generated/app_localizations.dart';
import '../../data/models/media_file.dart';
import '../../data/models/playlist.dart';
import 'audio_player_screen.dart';
import 'video_player_screen.dart';

class PlaylistScreen extends StatefulWidget {
  final Playlist? playlist;

  const PlaylistScreen({super.key, this.playlist});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen>
    with TickerProviderStateMixin {
  List<MediaFile> _playlistFiles = [];
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadPlaylistFiles();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadPlaylistFiles() async {
    if (widget.playlist != null) {
      final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
      final files = await mediaProvider.getPlaylistMediaFiles(
        widget.playlist!.id!,
      ); // Changed to use getPlaylistMediaFiles
      if (!mounted) return;
      setState(() {
        _playlistFiles = files;
        _isLoading = false;
      });
      _animationController.forward();
    } else {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.primaryBackgroundColor,
          body: _isLoading
              ? _buildLoadingScreen(themeProvider, l10n)
              : _buildMainContent(themeProvider, l10n),
          floatingActionButton:
              widget.playlist != null && _playlistFiles.isNotEmpty
              ? FloatingActionButton.extended(
                  onPressed: _playAll,
                  backgroundColor: Theme.of(context).primaryColor,
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  label: Text(
                    l10n.playAll,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null,
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
            l10n.loadingPlaylist,
            style: TextStyle(
              color: themeProvider.primaryTextColor,
              fontSize: 16,
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
    return CustomScrollView(
      slivers: [
        _buildAppBar(themeProvider, l10n),
        if (widget.playlist != null)
          _buildPlaylistInfo(themeProvider, l10n),
        _buildFilesList(themeProvider, l10n),
      ],
    );
  }

  Widget _buildAppBar(ThemeProvider themeProvider, AppLocalizations l10n) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.playlist?.name ?? l10n.playlist,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ],
            ),
          ),
        ),
      ),
      actions: [
        if (widget.playlist != null) ...[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _showAddMediaDialog,
            tooltip: l10n.addFiles,
          ),
          PopupMenuButton<String>(
            onSelected: (action) {
              final l10n = AppLocalizations.of(context)!;
              _handleMenuAction(action, l10n);
            },
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit),
                    const SizedBox(width: 8),
                    Text(l10n.editPlaylist),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'shuffle',
                child: Row(
                  children: [
                    const Icon(Icons.shuffle),
                    const SizedBox(width: 8),
                    Text(l10n.shufflePlay),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      l10n.deletePlaylist,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPlaylistInfo(
    ThemeProvider themeProvider,
    AppLocalizations l10n,
  ) {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: themeProvider.cardBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: themeProvider.shadowColor,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Hero(
                    tag: 'playlist_${widget.playlist!.id}',
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.indigo],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.playlist_play_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.playlist!.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.primaryTextColor,
                          ),
                        ),
                        if (widget.playlist!.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.playlist!.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: themeProvider.secondaryTextColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    icon: Icons.queue_music,
                    label: l10n.totalFiles,
                    value: '${_playlistFiles.length}',
                    color: Colors.blue,
                  ),
                  _buildStatItem(
                    icon: Icons.music_note,
                    label: l10n.audioFiles,
                    value:
                        '${_playlistFiles.where((f) => f.type == 'audio').length}',
                    color: Colors.purple,
                  ),
                  _buildStatItem(
                    icon: Icons.video_library,
                    label: l10n.videoFiles,
                    value:
                        '${_playlistFiles.where((f) => f.type == 'video').length}',
                    color: Colors.orange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1), // Fixed
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFilesList(
    ThemeProvider themeProvider,
    AppLocalizations l10n,
  ) {
    if (_playlistFiles.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(themeProvider, l10n),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: AnimationLimiter(
        child: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final file = _playlistFiles[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildMediaListTile(
                    file,
                    index: index,
                    themeProvider: themeProvider, // New
                    l10n: l10n, // New
                  ),
                ),
              ),
            );
          }, childCount: _playlistFiles.length),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    ThemeProvider themeProvider,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: themeProvider.primaryTextColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.playlist_add_rounded,
              size: 60,
              color: themeProvider.primaryTextColor.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.playlistIsEmpty,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeProvider.primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.addSomeFiles,
            style: TextStyle(
              fontSize: 16,
              color: themeProvider.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (widget.playlist != null)
            ElevatedButton.icon(
              onPressed: _showAddMediaDialog,
              icon: const Icon(Icons.add),
              label: Text(l10n.addFiles),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.currentTheme.colorScheme.primary,
                foregroundColor:
                    themeProvider.currentTheme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMediaListTile(
    MediaFile file, {
    int? index,
    required ThemeProvider themeProvider, // New
    required AppLocalizations l10n, // New
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      color: themeProvider.cardBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Hero(
          tag: 'file_${file.id}_${index ?? ''}',
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: file.type == 'audio'
                  ? themeProvider.currentTheme.colorScheme.primary.withValues(
                      alpha: 0.1,
                    )
                  : themeProvider.currentTheme.colorScheme.secondary.withValues(
                      alpha: 0.1,
                    ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              file.type == 'audio'
                  ? Icons.music_note_rounded
                  : Icons.video_library_rounded,
              color: file.type == 'audio'
                  ? themeProvider.currentTheme.colorScheme.primary
                  : themeProvider.currentTheme.colorScheme.secondary,
              size: 28,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                file.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: file.isMissing
                      ? themeProvider.secondaryTextColor.withValues(alpha: 0.6)
                      : themeProvider.primaryTextColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (file.isMissing)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.cloud_off_rounded,
                  size: 20,
                  color: themeProvider.currentTheme.colorScheme.error,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${file.formattedDuration} • ${file.formattedSize}',
              style: TextStyle(
                color: file.isMissing
                    ? themeProvider.secondaryTextColor.withValues(alpha: 0.4)
                    : themeProvider.secondaryTextColor,
                fontSize: 14,
              ),
            ),
            if (file.playCount > 0) ...[
              const SizedBox(height: 2),
              Text(
                l10n.playedTimes(file.playCount),
                style: TextStyle(
                  color: file.isMissing
                      ? themeProvider.secondaryTextColor.withValues(alpha: 0.4)
                      : themeProvider.secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (file.isFavorite)
              Icon(
                Icons.favorite,
                color: themeProvider.currentTheme.colorScheme.error,
                size: 20,
              ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) => _handleFileAction(
                value,
                file,
                index ?? 0,
                l10n,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'play',
                  enabled: !file.isMissing, // Disable if file is missing
                  child: Row(
                    children: [
                      const Icon(Icons.play_arrow),
                      const SizedBox(width: 8),
                      Text(l10n.play),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'favorite',
                  child: Row(
                    children: [
                      Icon(
                        file.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        file.isFavorite
                            ? l10n.removeFromFavorites
                            : l10n.addToFavorites,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'remove',
                  enabled: !file.isMissing, // Disable if file is missing
                  child: Row(
                    children: [
                      Icon(
                        Icons.remove_circle_outline,
                        color: themeProvider.currentTheme.colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.removeFromPlaylist,
                        style: TextStyle(
                          color: themeProvider.currentTheme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => file.isMissing
            ? _showMissingFileMessage(file.name, l10n)
            : _playMediaFile(file, index ?? 0),
      ),
    );
  }

  void _playMediaFile(MediaFile file, int index) {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    // Set current playlist and file
    if (widget.playlist != null) {
      mediaProvider.setCurrentPlaylist(widget.playlist);
    }
    // Fixed: setCurrentMediaFile takes MediaFile only
    mediaProvider.setCurrentMediaFile(file);

    if (file.type == 'audio') {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const AudioPlayerScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      );
    } else {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const VideoPlayerScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      );
    }
  }

  void _playAll() {
    if (_playlistFiles.isNotEmpty) {
      _playMediaFile(_playlistFiles.first, 0);
    }
  }

  void _showAddMediaDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => _AddMediaDialog(
        playlist: widget.playlist!,
        onFilesAdded: _loadPlaylistFiles,
        l10n: l10n,
      ),
    );
  }

  void _handleMenuAction(String action, AppLocalizations l10n) async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    switch (action) {
      case 'edit':
        final result = await showDialog<Map<String, String>>(
          context: context,
          builder: (context) => _EditPlaylistDialog(
            playlist: widget.playlist!,
            themeProvider: Provider.of<ThemeProvider>(context, listen: false),
            l10n: l10n, // Use local l10n
          ),
        );

        if (result != null) {
          final updatedPlaylist = widget.playlist!.copyWith(
            name: result['name'],
            description: result['description'],
            lastModified: DateTime.now(),
          );

          await mediaProvider.updatePlaylist(updatedPlaylist);
          setState(() {});

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Playlist updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
        break;

      case 'shuffle':
        if (_playlistFiles.isNotEmpty) {
          final shuffledFiles = List<MediaFile>.from(_playlistFiles)..shuffle();
          _playMediaFile(shuffledFiles.first, 0);
        }
        break;

      case 'delete':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Delete Playlist'),
            content: Text(
              'Are you sure you want to delete "${widget.playlist!.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          await mediaProvider.deletePlaylist(
            widget.playlist!,
          ); // Fixed: Pass playlist object

          if (!mounted) return;
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Playlist deleted successfully'),
              backgroundColor: Colors.red,
            ),
          );
        }
        break;
    }
  }

  void _handleFileAction(
    String action,
    MediaFile file,
    int index,
    AppLocalizations l10n,
  ) async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    switch (action) {
      case 'play':
        _playMediaFile(file, index);
        break;

      case 'favorite':
        await mediaProvider.toggleFavorite(file);
        _loadPlaylistFiles();
        break;

      case 'remove':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(l10n.removeFromPlaylist),
            content: Text(
              l10n.confirmRemoveFromFile(file.name),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(l10n.remove),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          await mediaProvider.removeFromPlaylist(widget.playlist!, file);
          _loadPlaylistFiles();

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File removed from playlist'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        break;
    }
  }

  void _showMissingFileMessage(String fileName, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${l10n.fileNotFound}: $fileName',
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class _AddMediaDialog extends StatefulWidget {
  final Playlist playlist;
  final VoidCallback onFilesAdded;
  final AppLocalizations l10n;

  const _AddMediaDialog({
    required this.playlist,
    required this.onFilesAdded,
    required this.l10n,
  });

  @override
  State<_AddMediaDialog> createState() => _AddMediaDialogState();
}

class _AddMediaDialogState extends State<_AddMediaDialog> {
  final List<MediaFile> _availableFiles = [];
  final List<MediaFile> _selectedFiles = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAvailableFiles();
  }

  Future<void> _loadAvailableFiles() async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    final allFiles = mediaProvider.allMediaFiles;
    final playlistFiles = await mediaProvider.getPlaylistMediaFiles(
      widget.playlist.id!,
    ); // Fixed: Use getPlaylistMediaFiles

    // Filter out files already in playlist
    final playlistFileIds = playlistFiles.map((f) => f.id).toSet();
    final availableFiles = allFiles
        .where((f) => !playlistFileIds.contains(f.id))
        .toList();

    if (!mounted) return;
    setState(() {
      _availableFiles.clear();
      _availableFiles.addAll(availableFiles);
      _isLoading = false;
    });
  }

  List<MediaFile> get _filteredFiles {
    if (_searchQuery.isEmpty) return _availableFiles;
    return _availableFiles
        .where(
          (file) =>
              file.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.maxFinite,
        height: 600,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.l10n.addFilesToPlaylist(widget.playlist.name),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: widget.l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Selected count
            if (_selectedFiles.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      widget.l10n.filesSelected(_selectedFiles.length),
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Files list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredFiles.isEmpty
                  ? Center(
                      child: Text(
                        widget.l10n.noFilesAvailableToAdd,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredFiles.length,
                      itemBuilder: (context, index) {
                        final file = _filteredFiles[index];
                        final isSelected = _selectedFiles.contains(file);

                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (selected) {
                            setState(() {
                              if (selected == true) {
                                _selectedFiles.add(file);
                              } else {
                                _selectedFiles.remove(file);
                              }
                            });
                          },
                          title: Text(
                            file.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(file.formattedDuration),
                          secondary: Icon(
                            file.type == 'audio'
                                ? Icons.music_note
                                : Icons.video_library,
                            color: file.type == 'audio'
                                ? Colors.purple
                                : Colors.orange,
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(widget.l10n.cancel),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _selectedFiles.isEmpty ? null : _addSelectedFiles,
                  child: Text(
                    widget.l10n.addWithCount(_selectedFiles.length),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addSelectedFiles() async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    for (final file in _selectedFiles) {
      await mediaProvider.addToPlaylist(widget.playlist, file);
    }

    widget.onFilesAdded();

    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.l10n.addedFilesToPlaylist(_selectedFiles.length),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class _EditPlaylistDialog extends StatefulWidget {
  final Playlist playlist;
  final ThemeProvider themeProvider; // New: ThemeProvider parameter
  final AppLocalizations l10n; // New: AppLocalizations parameter

  const _EditPlaylistDialog({
    required this.playlist,
    required this.themeProvider,
    required this.l10n,
  });

  @override
  State<_EditPlaylistDialog> createState() => _EditPlaylistDialogState();
}

class _EditPlaylistDialogState extends State<_EditPlaylistDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.playlist.name);
    _descriptionController = TextEditingController(
      text: widget.playlist.description,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.themeProvider.cardColor, // Use themeProvider
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.l10n.editPlaylist, // Use l10n
        style: TextStyle(color: widget.themeProvider.primaryTextColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: widget.l10n.playlistName, // Use l10n
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: widget.l10n.descriptionOptional, // Use l10n
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            widget.l10n.cancel, // Use l10n
            style: TextStyle(
              color: widget.themeProvider.currentTheme.colorScheme.primary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'name': _nameController.text,
              'description': _descriptionController.text,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                widget.themeProvider.currentTheme.colorScheme.primary,
            foregroundColor:
                widget.themeProvider.currentTheme.colorScheme.onPrimary,
          ), // Use themeProvider
          child: Text(widget.l10n.save), // Use l10n
        ),
      ],
    );
  }
}
