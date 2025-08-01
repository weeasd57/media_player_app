import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/media_provider.dart';
import '../providers/theme_provider.dart';
import '../../data/models/playlist.dart';
import '../../generated/app_localizations.dart';
import 'playlist_screen.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.primaryBackgroundColor,
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.playlists,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: _createPlaylist,
                icon: const Icon(Icons.add),
                tooltip: AppLocalizations.of(context)!.createPlaylist,
              ),
            ],
          ),
          body: Consumer<MediaProvider>(
            builder: (context, mediaProvider, child) {
              if (mediaProvider.playlists.isEmpty) {
                return _buildEmptyState(context, themeProvider);
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: mediaProvider.playlists.length,
                itemBuilder: (context, index) {
                  final playlist = mediaProvider.playlists[index];
                  return _buildPlaylistCard(
                    context,
                    playlist,
                    index,
                    themeProvider,
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _createPlaylist(),
            backgroundColor: themeProvider.currentTheme.colorScheme.primary,
            icon: Icon(
              Icons.add,
              color: themeProvider.currentTheme.colorScheme.onPrimary,
            ),
            label: Text(
              AppLocalizations.of(context)!.createPlaylist,
              style: TextStyle(
                color: themeProvider.currentTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeProvider themeProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: themeProvider.currentTheme.colorScheme.primary.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.playlist_add_rounded,
              size: 60,
              color: themeProvider.currentTheme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.noPlaylistsYet,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeProvider.primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.createFirstPlaylist,
            style: TextStyle(
              fontSize: 16,
              color: themeProvider.secondaryTextColor,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _createPlaylist,
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context)!.createPlaylist),
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

  Widget _buildPlaylistCard(
    BuildContext context,
    Playlist playlist,
    int index,
    ThemeProvider themeProvider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: themeProvider.cardBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _openPlaylist(playlist),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Hero(
                tag: 'playlist_${playlist.id}',
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _getPlaylistColors(index),
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _getPlaylistColors(
                          index,
                        )[0].withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.playlist_play_rounded,
                    color: themeProvider.iconColor,
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
                      playlist.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.primaryTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (playlist.description.isNotEmpty) ...[
                      Text(
                        playlist.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: themeProvider.secondaryTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                    ],
                    Row(
                      children: [
                        Icon(
                          Icons.music_note,
                          size: 16,
                          color: themeProvider.secondaryTextColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.filesCount(playlist.mediaCount),
                          style: TextStyle(
                            fontSize: 14,
                            color: themeProvider.secondaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: themeProvider.secondaryTextColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(playlist.lastModified),
                          style: TextStyle(
                            fontSize: 14,
                            color: themeProvider.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handlePlaylistAction(value, playlist),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'play',
                    child: Row(
                      children: [
                        const Icon(Icons.play_arrow),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.playAll),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.edit),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        const Icon(Icons.copy),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.duplicate),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: themeProvider.currentTheme.colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.delete,
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
        ),
      ),
    );
  }

  List<Color> _getPlaylistColors(int index) {
    final colorSets = [
      [Colors.blue, Colors.purple],
      [Colors.purple, Colors.pink],
      [Colors.orange, Colors.red],
      [Colors.green, Colors.teal],
      [Colors.indigo, Colors.blue],
      [Colors.pink, Colors.purple],
    ];
    return colorSets[index % colorSets.length];
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return AppLocalizations.of(context)!.today;
    } else if (difference.inDays == 1) {
      return AppLocalizations.of(context)!.yesterday;
    } else if (difference.inDays < 7) {
      return AppLocalizations.of(context)!.daysAgo(difference.inDays);
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _openPlaylist(Playlist playlist) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PlaylistScreen(playlist: playlist),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void _createPlaylist() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _CreatePlaylistDialog(
        themeProvider: Provider.of<ThemeProvider>(context, listen: false),
        textProvider: AppLocalizations.of(context)!,
      ),
    );

    if (result != null && result['name']!.isNotEmpty) {
      if (!mounted) return;
      final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
      await mediaProvider.createPlaylist(
        result['name']!,
        description: result['description'] ?? '',
      );

      if (!mounted) return;
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.playlistCreated),
          backgroundColor: themeProvider.currentTheme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _handlePlaylistAction(String action, Playlist playlist) async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    switch (action) {
      case 'play':
        final files = await mediaProvider.getPlaylistMediaFiles(
          playlist.id!,
        ); // Fixed
        if (files.isNotEmpty) {
          mediaProvider.setCurrentPlaylist(playlist);
          mediaProvider.setCurrentMediaFile(files.first);
          _openPlaylist(playlist);
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.playlistIsEmpty),
              backgroundColor: Colors.orange,
            ),
          );
        }
        break;

      case 'edit':
        final result = await showDialog<Map<String, String>>(
          context: context,
          builder: (context) => _EditPlaylistDialog(
            playlist: playlist,
            themeProvider: Provider.of<ThemeProvider>(context, listen: false),
            textProvider: AppLocalizations.of(context)!,
          ),
        );

        if (result != null) {
          final updatedPlaylist = playlist.copyWith(
            name: result['name'],
            description: result['description'],
            lastModified: DateTime.now(),
          );

          await mediaProvider.updatePlaylist(updatedPlaylist);

          if (!mounted) return;
          final themeProvider = Provider.of<ThemeProvider>(
            context,
            listen: false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.playlistUpdated),
              backgroundColor: themeProvider.currentTheme.colorScheme.primary,
            ),
          );
        }
        break;

      case 'duplicate':
        // No longer returning a value from createPlaylist
        await mediaProvider.createPlaylist(
          '${playlist.name} (Copy)',
          description: playlist.description,
        );

        // Re-load playlists after duplication to get the new one
        // Assuming mediaProvider will notify listeners after creation

        if (!mounted) return;
        final themeProvider = Provider.of<ThemeProvider>(
          context,
          listen: false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.playlistDuplicated),
            backgroundColor: themeProvider.currentTheme.colorScheme.primary,
          ),
        );
        break;

      case 'delete':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(AppLocalizations.of(context)!.deletePlaylist),
            content: Text(
              AppLocalizations.of(
                context,
              )!.deletePlaylistConfirmation(playlist.name),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: Text(AppLocalizations.of(context)!.delete),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          await mediaProvider.deletePlaylist(playlist);

          if (!mounted) return;
          final themeProvider = Provider.of<ThemeProvider>(
            context,
            listen: false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.playlistDeleted),
              backgroundColor: themeProvider.currentTheme.colorScheme.error,
            ),
          );
        }
        break;
    }
  }
}

class _CreatePlaylistDialog extends StatefulWidget {
  final ThemeProvider themeProvider;
  final AppLocalizations textProvider;
  const _CreatePlaylistDialog({
    required this.themeProvider,
    required this.textProvider,
  });

  @override
  State<_CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<_CreatePlaylistDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.themeProvider.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.textProvider.createPlaylist,
        style: TextStyle(color: widget.themeProvider.primaryTextColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: widget.textProvider.playlistName,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: widget.textProvider.descriptionOptional,
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
            widget.textProvider.cancel,
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
          ),
          child: Text(widget.textProvider.create),
        ),
      ],
    );
  }
}

class _EditPlaylistDialog extends StatefulWidget {
  final Playlist playlist;
  final ThemeProvider themeProvider; // New: ThemeProvider parameter
  final AppLocalizations textProvider; // New: AppLocalizations parameter

  const _EditPlaylistDialog({
    required this.playlist,
    required this.themeProvider,
    required this.textProvider,
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
        widget.textProvider.edit, // Use textProvider
        style: TextStyle(
          color: widget.themeProvider.primaryTextColor,
        ), // Use themeProvider
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: widget.textProvider.playlistName, // Use textProvider
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText:
                  widget.textProvider.descriptionOptional, // Use textProvider
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
            widget.textProvider.cancel,
            style: TextStyle(
              color: widget.themeProvider.currentTheme.colorScheme.primary,
            ),
          ), // Use textProvider and themeProvider
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
          child: Text(widget.textProvider.save),
        ),
      ],
    );
  }
}
