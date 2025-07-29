import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/media_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/text_provider.dart';
import '../../data/models/media_file.dart';
import 'audio_player_screen.dart';
import 'video_player_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _sortBy = 'name';
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, TextProvider>(
      builder: (context, themeProvider, textProvider, child) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        
        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: Text(
              textProvider.getText('library'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
            elevation: 0,
            actions: [
              PopupMenuButton<String>(
                onSelected: _handleSort,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'name',
                    child: Row(
                      children: [
                        const Icon(Icons.sort_by_alpha),
                        const SizedBox(width: 8),
                        Text(textProvider.getText('sort_by_name')),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'date',
                    child: Row(
                      children: [
                        const Icon(Icons.access_time),
                        const SizedBox(width: 8),
                        Text(textProvider.getText('sort_by_date')),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'size',
                    child: Row(
                      children: [
                        const Icon(Icons.storage),
                        const SizedBox(width: 8),
                        Text(textProvider.getText('sort_by_size')),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.6),
              indicatorColor: colorScheme.primary,
              tabs: [
                Tab(text: textProvider.getText('all_files')),
                Tab(text: textProvider.getText('audio_files')),
                Tab(text: textProvider.getText('video_files')),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildAllFilesTab(themeProvider, textProvider),
              _buildAudioTab(themeProvider, textProvider),
              _buildVideoTab(themeProvider, textProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAllFilesTab(
    ThemeProvider themeProvider,
    TextProvider textProvider,
  ) {
    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        final files = _sortFiles(mediaProvider.allMediaFiles);

        if (files.isEmpty) {
          return _buildEmptyState(
            textProvider.getText('no_files_found'),
            Icons.library_music,
            Theme.of(context).colorScheme,
            textProvider,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: files.length,
          itemBuilder: (context, index) {
            return _buildMediaListTile(
              files[index],
              index,
              themeProvider,
              textProvider,
            );
          },
        );
      },
    );
  }

  Widget _buildAudioTab(
    ThemeProvider themeProvider,
    TextProvider textProvider,
  ) {
    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        return FutureBuilder<List<MediaFile>>(
          future: mediaProvider.getMediaFilesByType('audio'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return _buildEmptyState(
                textProvider.getText('error'),
                Icons.error,
                Theme.of(context).colorScheme,
                textProvider,
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState(
                textProvider.getText('no_files_found'),
                Icons.music_note,
                Theme.of(context).colorScheme,
                textProvider,
              );
            } else {
              final files = _sortFiles(snapshot.data!);
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return _buildMediaListTile(
                    files[index],
                    index,
                    themeProvider,
                    textProvider,
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  Widget _buildVideoTab(
    ThemeProvider themeProvider,
    TextProvider textProvider,
  ) {
    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        return FutureBuilder<List<MediaFile>>(
          future: mediaProvider.getMediaFilesByType('video'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return _buildEmptyState(
                textProvider.getText('error'),
                Icons.error,
                Theme.of(context).colorScheme,
                textProvider,
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState(
                textProvider.getText('no_files_found'),
                Icons.video_library,
                Theme.of(context).colorScheme,
                textProvider,
              );
            } else {
              final files = _sortFiles(snapshot.data!);
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return _buildMediaListTile(
                    files[index],
                    index,
                    themeProvider,
                    textProvider,
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  Widget _buildEmptyState(
    String message,
    IconData icon,
    ColorScheme colorScheme,
    TextProvider textProvider,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: colorScheme.onSurface.withValues(alpha: 0.6)),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _scanForFiles,
            icon: const Icon(Icons.refresh),
            label: Text(textProvider.getText('scan_files')),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
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

  Widget _buildMediaListTile(
    MediaFile file,
    int index,
    ThemeProvider themeProvider,
    TextProvider textProvider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Hero(
          tag: 'media_${file.id}',
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: file.type == 'audio'
                  ? Colors.purple.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              file.type == 'audio'
                  ? Icons.music_note_rounded
                  : Icons.video_library_rounded,
              color: file.type == 'audio' ? Colors.purple : Colors.orange,
              size: 28,
            ),
          ),
        ),
        title: Text(
          file.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: themeProvider.primaryTextColor,
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
                color: themeProvider.secondaryTextColor,
                fontSize: 14,
              ),
            ),
            if (file.playCount > 0) ...[
              const SizedBox(height: 2),
              Text(
                '${textProvider.getText('playing')} ${file.playCount} ${textProvider.getText('playing')}',
                style: TextStyle(
                  color: themeProvider.secondaryTextColor,
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
              const Icon(Icons.favorite, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) => _handleFileAction(value, file, textProvider),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'play',
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
                            ? textProvider.getText('remove_from_playlist')
                            : textProvider.getText('add_to_playlist'),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'addToPlaylist',
                  child: Row(
                    children: [
                      const Icon(Icons.playlist_add),
                      const SizedBox(width: 8),
                      Text(textProvider.getText('add_to_playlist')),
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
                        textProvider.getText('delete'),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _playMediaFile(file),
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
      case 'size':
        sortedFiles.sort(
          (a, b) => _isAscending
              ? a.size.compareTo(b.size)
              : b.size.compareTo(a.size),
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

  void _playMediaFile(MediaFile file) {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    mediaProvider.setCurrentMediaFile(file);

    // Added for playcount update
    mediaProvider.updatePlayCount(
      file.id!,
    ); // Fixed: Ensure updatePlayCount is called correctly

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
    String action,
    MediaFile file,
    TextProvider textProvider,
  ) async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    switch (action) {
      case 'play':
        _playMediaFile(file);
        break;

      case 'favorite':
        await mediaProvider.toggleFavorite(file);
        break;

      case 'addToPlaylist':
        _showAddToPlaylistDialog(file);
        break;

      case 'delete':
        _showDeleteConfirmation(file);
        break;
    }
  }

  void _showAddToPlaylistDialog(MediaFile file) {
    showDialog(
      context: context,
      builder: (context) => _AddToPlaylistDialog(file: file),
    );
  }

  void _showDeleteConfirmation(MediaFile file) {
    showDialog(
      context: context,
      builder: (context) => Consumer2<ThemeProvider, TextProvider>(
        builder: (context, themeProvider, textProvider, child) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            textProvider.getText('delete'),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          content: Text(
            '${textProvider.getText('delete_playlist_confirmation')} "${file.name}"?',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(textProvider.getText('cancel'), style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
            ElevatedButton(
              onPressed: () async {
                final mediaProvider = Provider.of<MediaProvider>(
                  context,
                  listen: false,
                );
                await mediaProvider.deleteMediaFile(file);
                if (!mounted) return;
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(textProvider.getText('success')),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
              child: Text(textProvider.getText('delete'), style: TextStyle(color: Theme.of(context).colorScheme.onError)),
            ),
          ],
        ),
      ),
    );
  }

  void _scanForFiles() async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    await mediaProvider.scanForMediaFiles();
  }
}

class _AddToPlaylistDialog extends StatelessWidget {
  final MediaFile file;

  const _AddToPlaylistDialog({required this.file});

  @override
  Widget build(BuildContext context) {
    return Consumer3<MediaProvider, ThemeProvider, TextProvider>(
      builder: (context, mediaProvider, themeProvider, textProvider, child) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            textProvider.getText('add_to_playlist'),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: mediaProvider.playlists.isEmpty
                ? Center(
                    child: Text(
                      textProvider.getText('empty_playlist'),
                      style: TextStyle(color: themeProvider.secondaryTextColor),
                    ),
                  )
                : ListView.builder(
                    itemCount: mediaProvider.playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = mediaProvider.playlists[index];
                      return ListTile(
                        leading: const Icon(Icons.playlist_play),
                        title: Text(
                          playlist.name,
                          style: TextStyle(color: themeProvider.primaryTextColor),
                        ),
                        subtitle: Text(
                          '${playlist.mediaCount} ${textProvider.getText('all_files')}',
                          style: TextStyle(color: themeProvider.secondaryTextColor),
                        ),
                        onTap: () async {
                          await mediaProvider.addToPlaylist(playlist, file);
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${textProvider.getText('playlist_created')} ${playlist.name}',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
child: Text(textProvider.getText('cancel'), style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        );
      },
    );
  }
}
