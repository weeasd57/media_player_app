import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/media_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/text_provider.dart';
import '../../data/models/media_file.dart';
import 'audio_player_screen.dart';
import 'video_player_screen.dart';
import 'package:media_player_app/services/media_playback_service.dart';

class RecentPlayedScreen extends StatelessWidget {
  const RecentPlayedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<MediaProvider, ThemeProvider, TextProvider>(
      builder: (context, mediaProvider, themeProvider, textProvider, child) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: Text(
              textProvider.getText('recentlyPlayed'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
            elevation: 0,
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(
                  context,
                  value,
                  mediaProvider,
                  textProvider,
                  themeProvider,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'clear',
                    child: Row(
                      children: [
                        const Icon(Icons.clear_all),
                        const SizedBox(width: 8),
                        Text(textProvider.getText('clearHistory')),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: _buildRecentFilesList(
            mediaProvider,
            themeProvider,
            textProvider,
          ),
        );
      },
    );
  }

  Widget _buildRecentFilesList(
    MediaProvider mediaProvider,
    ThemeProvider themeProvider,
    TextProvider textProvider,
  ) {
    // Get recent files sorted by last played time
    final recentFiles = mediaProvider.recentFiles
        .where((file) => file.lastPlayed.isAfter(
              DateTime.now().subtract(const Duration(days: 30)),
            ))
        .toList();

    if (recentFiles.isEmpty) {
      return _buildEmptyState(themeProvider, textProvider);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recentFiles.length,
      itemBuilder: (context, index) {
        final file = recentFiles[index];
        return _buildRecentFileItem(
          context,
          file,
          index,
          themeProvider,
          textProvider,
        );
      },
    );
  }

  Widget _buildRecentFileItem(
    BuildContext context,
    MediaFile file,
    int index,
    ThemeProvider themeProvider,
    TextProvider textProvider,
  ) {
    final timeDifference = DateTime.now().difference(file.lastPlayed);
    String timeAgo;

    if (timeDifference.inDays > 0) {
      timeAgo = '${timeDifference.inDays} ${textProvider.getText('daysAgo')}';
    } else if (timeDifference.inHours > 0) {
      timeAgo = '${timeDifference.inHours} ${textProvider.getText('hoursAgo')}';
    } else if (timeDifference.inMinutes > 0) {
      timeAgo = '${timeDifference.inMinutes} ${textProvider.getText('minutesAgo')}';
    } else {
      timeAgo = textProvider.getText('justNow');
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Hero(
          tag: 'recent_media_${file.id}',
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
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 12,
                  color: themeProvider.secondaryTextColor.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  timeAgo,
                  style: TextStyle(
                    color: themeProvider.secondaryTextColor.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                if (file.playCount > 1) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.repeat,
                    size: 12,
                    color: themeProvider.secondaryTextColor.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${file.playCount}x',
                    style: TextStyle(
                      color: themeProvider.secondaryTextColor.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
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
                context,
                value,
                file,
                textProvider,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'play',
                  enabled: !file.isMissing,
                  child: Row(
                    children: [
                      const Icon(Icons.play_arrow),
                      const SizedBox(width: 8),
                      Text(textProvider.getText('play')),
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
                            ? textProvider.getText('removeFromFavorites')
                            : textProvider.getText('addToFavorites'),
                      ),
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
                      Text(textProvider.getText('addToPlaylist')),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'removeFromHistory',
                  child: Row(
                    children: [
                      Icon(
                        Icons.history_toggle_off,
                        color: themeProvider.currentTheme.colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        textProvider.getText('removeFromHistory'),
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
            ? _showMissingFileMessage(context, file.name, textProvider)
            : _playMediaFile(context, file),
      ),
    );
  }

  Widget _buildEmptyState(
    ThemeProvider themeProvider,
    TextProvider textProvider,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: themeProvider.iconColor,
          ),
          const SizedBox(height: 16),
          Text(
            textProvider.getText('noRecentFiles'),
            style: TextStyle(
              fontSize: 18,
              color: themeProvider.primaryTextColor.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            textProvider.getText('noRecentFilesDescription'),
            style: TextStyle(
              fontSize: 14,
              color: themeProvider.secondaryTextColor.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
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
    TextProvider textProvider,
  ) async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    switch (action) {
      case 'play':
        _playMediaFile(context, file);
        break;

      case 'favorite':
        await mediaProvider.toggleFavorite(file);
        break;

      case 'addToPlaylist':
        _showAddToPlaylistDialog(context, file);
        break;

      case 'removeFromHistory':
        _showRemoveFromHistoryDialog(context, file, textProvider);
        break;
    }
  }

  void _handleMenuAction(
    BuildContext context,
    String action,
    MediaProvider mediaProvider,
    TextProvider textProvider,
    ThemeProvider themeProvider,
  ) {
    switch (action) {
      case 'clear':
        _showClearHistoryDialog(
          context,
          mediaProvider,
          textProvider,
          themeProvider,
        );
        break;
    }
  }

  void _showAddToPlaylistDialog(BuildContext context, MediaFile file) {
    // This would be implemented similar to the library screen
    // For now, showing a simple message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Add to playlist feature coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showRemoveFromHistoryDialog(
    BuildContext context,
    MediaFile file,
    TextProvider textProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => AlertDialog(
          backgroundColor: themeProvider.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            textProvider.getText('removeFromHistory'),
            style: TextStyle(color: themeProvider.primaryTextColor),
          ),
          content: Text(
            textProvider.getText('removeFromHistoryConfirmation')
                .replaceAll('{fileName}', file.name),
            style: TextStyle(color: themeProvider.secondaryTextColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                textProvider.getText('cancel'),
                style: TextStyle(
                  color: themeProvider.currentTheme.colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Reset last played date to remove from recent list
                final updatedFile = file.copyWith(
                  lastPlayed: DateTime(1970), // Very old date
                );
                Provider.of<MediaProvider>(context, listen: false)
                    .updateMediaFile(updatedFile);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(textProvider.getText('removedFromHistory')),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.currentTheme.colorScheme.error,
              ),
              child: Text(
                textProvider.getText('remove'),
                style: TextStyle(
                  color: themeProvider.currentTheme.colorScheme.onError,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearHistoryDialog(
    BuildContext context,
    MediaProvider mediaProvider,
    TextProvider textProvider,
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
          textProvider.getText('clearHistory'),
          style: TextStyle(color: themeProvider.primaryTextColor),
        ),
        content: Text(
          textProvider.getText('clearHistoryConfirmation'),
          style: TextStyle(color: themeProvider.secondaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              textProvider.getText('cancel'),
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
              
              // Reset all files' last played date
              final oldDate = DateTime(1970);
              for (final file in mediaProvider.allMediaFiles) {
                final updatedFile = file.copyWith(lastPlayed: oldDate);
                await mediaProvider.updateMediaFile(updatedFile);
              }
              
              scaffold.showSnackBar(
                SnackBar(
                  content: Text(textProvider.getText('historyCleared')),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeProvider.currentTheme.colorScheme.error,
            ),
            child: Text(
              textProvider.getText('clear'),
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
    TextProvider textProvider,
  ) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              textProvider
                  .getText('fileNotFound')
                  .replaceAll('{fileName}', fileName),
            ),
            backgroundColor: Colors.red,
          ),
        );
  }
}
