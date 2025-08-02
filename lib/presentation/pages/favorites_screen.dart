import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/media_provider.dart';
import '../providers/theme_provider.dart';
import '../../generated/app_localizations.dart';
import '../../data/models/media_file.dart';
import 'audio_player_screen.dart';
import 'video_player_screen.dart';
import 'package:media_player_app/services/media_playback_service.dart';

enum FavoriteViewMode { list, grid }

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  FavoriteViewMode _viewMode = FavoriteViewMode.list;
  String _sortBy = 'name';
  bool _isAscending = true;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Consumer2<MediaProvider, ThemeProvider>(
      builder: (context, mediaProvider, themeProvider, child) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: Text(
              localizations.favorites,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(
                  _viewMode == FavoriteViewMode.list
                      ? Icons.grid_view
                      : Icons.list,
                ),
                onPressed: () {
                  setState(() {
                    _viewMode = _viewMode == FavoriteViewMode.list
                        ? FavoriteViewMode.grid
                        : FavoriteViewMode.list;
                  });
                },
              ),
              PopupMenuButton<String>(
                onSelected: _handleSort,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'name',
                    child: Row(
                      children: [
                        const Icon(Icons.sort_by_alpha),
                        const SizedBox(width: 8),
                        Text(localizations.sortByName),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'date',
                    child: Row(
                      children: [
                        const Icon(Icons.access_time),
                        const SizedBox(width: 8),
                        Text(localizations.sortByDate),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'type',
                    child: Row(
                      children: [
                        const Icon(Icons.category),
                        const SizedBox(width: 8),
                        Text(localizations.sortByName),
                      ],
                    ),
                  ),
                ],
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(
                  context,
                  value,
                  mediaProvider,
                  localizations,
                  themeProvider,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'clearAll',
                    child: Row(
                      children: [
                        Icon(
                          Icons.heart_broken,
                          color: themeProvider.currentTheme.colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          localizations.removeFromFavorites,
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
          body: _buildFavoritesList(
            mediaProvider,
            themeProvider,
            localizations,
          ),
        );
      },
    );
  }

  Widget _buildFavoritesList(
    MediaProvider mediaProvider,
    ThemeProvider themeProvider,
    AppLocalizations localizations,
  ) {
    final favoriteFiles = _sortFiles(mediaProvider.favoriteFiles);

    if (favoriteFiles.isEmpty) {
      return _buildEmptyState(themeProvider, localizations);
    }

    if (_viewMode == FavoriteViewMode.list) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favoriteFiles.length,
        itemBuilder: (context, index) {
          return _buildFavoriteListItem(
            context,
            favoriteFiles[index],
            index,
            themeProvider,
            localizations,
          );
        },
      );
    } else {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: favoriteFiles.length,
        itemBuilder: (context, index) {
          return _buildFavoriteGridItem(
            context,
            favoriteFiles[index],
            index,
            themeProvider,
            localizations,
          );
        },
      );
    }
  }

  Widget _buildFavoriteListItem(
    BuildContext context,
    MediaFile file,
    int index,
    ThemeProvider themeProvider,
    AppLocalizations localizations,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Hero(
          tag: 'favorite_media_${file.id}_${file.name}',
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: file.type == 'audio'
                  ? themeProvider.currentTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : themeProvider.currentTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Center(
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
                Positioned(
                  top: 4,
                  right: 4,
                  child: Icon(
                    Icons.favorite,
                    color: themeProvider.currentTheme.colorScheme.error,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        title: Text(
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
              Row(
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    size: 12,
                    color: themeProvider.secondaryTextColor.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    localizations.playedTimes(file.playCount),
                    style: TextStyle(
                      color: themeProvider.secondaryTextColor.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleFileAction(
            context,
            value,
            file,
            localizations,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'play',
              enabled: !file.isMissing,
              child: Row(
                children: [
                  const Icon(Icons.play_arrow),
                  const SizedBox(width: 8),
                  Text(localizations.play),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'addToPlaylist',
              enabled: !file.isMissing,
              child: Row(
                children: [
                  const Icon(Icons.playlist_add),
                  const SizedBox(width: 8),
                  Text(localizations.addToPlaylist),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'removeFromFavorites',
              child: Row(
                children: [
                  Icon(
                    Icons.heart_broken,
                    color: themeProvider.currentTheme.colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    localizations.removeFromFavorites,
                    style: TextStyle(
                      color: themeProvider.currentTheme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () => file.isMissing
            ? _showMissingFileMessage(context, file.name, localizations)
            : _playMediaFile(context, file),
      ),
    );
  }

  Widget _buildFavoriteGridItem(
    BuildContext context,
    MediaFile file,
    int index,
    ThemeProvider themeProvider,
    AppLocalizations localizations,
  ) {
    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => file.isMissing
            ? _showMissingFileMessage(context, file.name, localizations)
            : _playMediaFile(context, file),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'favorite_grid_media_${file.id}',
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: file.type == 'audio'
                      ? themeProvider.currentTheme.colorScheme.primary
                          .withValues(alpha: 0.1)
                      : themeProvider.currentTheme.colorScheme.secondary
                          .withValues(alpha: 0.1),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        file.type == 'audio'
                            ? Icons.music_note_rounded
                            : Icons.video_library_rounded,
                        color: file.type == 'audio'
                            ? themeProvider.currentTheme.colorScheme.primary
                            : themeProvider.currentTheme.colorScheme.secondary,
                        size: 48,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: themeProvider.currentTheme.colorScheme.error,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: file.isMissing
                          ? themeProvider.secondaryTextColor.withValues(alpha: 0.6)
                          : themeProvider.primaryTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    file.formattedDuration,
                    style: TextStyle(
                      color: file.isMissing
                          ? themeProvider.secondaryTextColor.withValues(alpha: 0.4)
                          : themeProvider.secondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
                  if (file.playCount > 0) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_outline,
                          size: 10,
                          color: themeProvider.secondaryTextColor.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${file.playCount}x',
                          style: TextStyle(
                            color: themeProvider.secondaryTextColor.withValues(alpha: 0.6),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    ThemeProvider themeProvider,
    AppLocalizations localizations,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: themeProvider.iconColor,
          ),
          const SizedBox(height: 16),
          Text(
            localizations.favorites.isEmpty ? 'No Favorites Yet' : 'لا توجد مفضلات بعد',
            style: TextStyle(
              fontSize: 18,
              color: themeProvider.primaryTextColor.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your favorite songs and videos will appear here',
            style: TextStyle(
              fontSize: 14,
              color: themeProvider.secondaryTextColor.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.library_music),
            label: Text(localizations.library),
            style: ElevatedButton.styleFrom(
              backgroundColor: themeProvider.currentTheme.colorScheme.primary,
              foregroundColor: themeProvider.currentTheme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<MediaFile> _sortFiles(List<MediaFile> files) {
    final sortedFiles = List<MediaFile>.from(files);

    switch (_sortBy) {
      case 'name':
        sortedFiles.sort(
          (a, b) => _isAscending
              ? a.name.compareTo(b.name)
              : b.name.compareTo(a.name),
        );
        break;
      case 'date':
        sortedFiles.sort(
          (a, b) => _isAscending
              ? a.dateAdded.compareTo(b.dateAdded)
              : b.dateAdded.compareTo(a.dateAdded),
        );
        break;
      case 'type':
        sortedFiles.sort(
          (a, b) => _isAscending
              ? a.type.compareTo(b.type)
              : b.type.compareTo(a.type),
        );
        break;
    }

    return sortedFiles;
  }

  void _handleSort(String sortType) {
    setState(() {
      if (_sortBy == sortType) {
        _isAscending = !_isAscending;
      } else {
        _sortBy = sortType;
        _isAscending = true;
      }
    });
  }

  void _playMediaFile(BuildContext context, MediaFile file) {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    final mediaPlaybackService = Provider.of<MediaPlaybackService>(
      context,
      listen: false,
    );
    
    mediaProvider.setCurrentMediaFile(file);
    mediaPlaybackService.playMedia(file);
    mediaProvider.updatePlayCount(file.id!);

    if (file.type == 'audio') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AudioPlayerScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VideoPlayerScreen()),
      );
    }
  }

  void _handleFileAction(
    BuildContext context,
    String action,
    MediaFile file,
    AppLocalizations localizations,
  ) async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    switch (action) {
      case 'play':
        _playMediaFile(context, file);
        break;

      case 'addToPlaylist':
        _showAddToPlaylistDialog(context, file);
        break;

      case 'removeFromFavorites':
        await mediaProvider.toggleFavorite(file);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.removedFromFavorites),
          ),
        );
        break;
    }
  }

  void _handleMenuAction(
    BuildContext context,
    String action,
    MediaProvider mediaProvider,
    AppLocalizations localizations,
    ThemeProvider themeProvider,
  ) {
    switch (action) {
      case 'clearAll':
        _showClearAllFavoritesDialog(
          context,
          mediaProvider,
          localizations,
          themeProvider,
        );
        break;
    }
  }

  void _showAddToPlaylistDialog(BuildContext context, MediaFile file) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Add to playlist feature coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showClearAllFavoritesDialog(
    BuildContext context,
    MediaProvider mediaProvider,
    AppLocalizations localizations,
    ThemeProvider themeProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Remove All Favorites',
          style: TextStyle(color: themeProvider.primaryTextColor),
        ),
        content: Text(
          'Are you sure you want to remove all favorites?',
          style: TextStyle(color: themeProvider.secondaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              localizations.cancel,
              style: TextStyle(
                color: themeProvider.currentTheme.colorScheme.primary,
              ),
            ),
          ),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final scaffold = ScaffoldMessenger.of(context);
                
                navigator.pop();
                
                // Remove all favorites
                final favoriteFiles = List<MediaFile>.from(mediaProvider.favoriteFiles);
                for (final file in favoriteFiles) {
                  await mediaProvider.toggleFavorite(file);
                }
                
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text('All favorites removed'),
                  ),
                );
              },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeProvider.currentTheme.colorScheme.error,
            ),
            child: Text(
              'Remove All',
              style: TextStyle(
                color: themeProvider.currentTheme.colorScheme.onError,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMissingFileMessage(
    BuildContext context,
    String fileName,
    AppLocalizations localizations,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          localizations.fileNotFound(fileName),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
