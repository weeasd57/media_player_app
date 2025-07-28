import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:media_player_app/generated/app_localizations.dart';
import '../providers/media_provider.dart';
import '../models/playlist.dart';
import 'playlist_screen.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.playlists,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
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
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: mediaProvider.playlists.length,
            itemBuilder: (context, index) {
              final playlist = mediaProvider.playlists[index];
              return _buildPlaylistCard(playlist, index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createPlaylist,
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          AppLocalizations.of(context)!.createPlaylist,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.playlist_add_rounded,
              size: 60,
              color: Colors.blue[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.noPlaylistsYet,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.createFirstPlaylist,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
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
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
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

  Widget _buildPlaylistCard(Playlist playlist, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
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
                        )[0].withValues(alpha: 0.3), // Fixed
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
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
                      playlist.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (playlist.description.isNotEmpty) ...[
                      Text(
                        playlist.description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context)!.filesCount(playlist.mediaCount),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(playlist.lastModified),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
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
                        const Icon(Icons.delete, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.delete,
                          style: const TextStyle(color: Colors.red),
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
      builder: (context) => const _CreatePlaylistDialog(),
    );

    if (result != null && result['name']!.isNotEmpty) {
      final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
      await mediaProvider.createPlaylist(
        result['name']!,
        description: result['description'] ?? '',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.playlistCreated),
          backgroundColor: Colors.green,
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
          builder: (context) => _EditPlaylistDialog(playlist: playlist),
        );

        if (result != null) {
          final updatedPlaylist = playlist.copyWith(
            name: result['name'],
            description: result['description'],
            lastModified: DateTime.now(),
          );

          await mediaProvider.updatePlaylist(updatedPlaylist);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.playlistUpdated),
              backgroundColor: Colors.green,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.playlistDuplicated),
            backgroundColor: Colors.green,
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
              AppLocalizations.of(context)!.deletePlaylistConfirmation(playlist.name),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(AppLocalizations.of(context)!.delete),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          await mediaProvider.deletePlaylist(playlist);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.playlistDeleted),
              backgroundColor: Colors.red,
            ),
          );
        }
        break;
    }
  }
}

class _CreatePlaylistDialog extends StatefulWidget {
  const _CreatePlaylistDialog();

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(AppLocalizations.of(context)!.createNewPlaylist),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.playlistName,
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
              labelText: AppLocalizations.of(context)!.descriptionOptional,
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
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'name': _nameController.text,
              'description': _descriptionController.text,
            });
          },
          child: Text(AppLocalizations.of(context)!.create),
        ),
      ],
    );
  }
}

class _EditPlaylistDialog extends StatefulWidget {
  final Playlist playlist;

  const _EditPlaylistDialog({required this.playlist});

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(AppLocalizations.of(context)!.editPlaylist),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.playlistName,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.descriptionOptional,
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
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'name': _nameController.text,
              'description': _descriptionController.text,
            });
          },
          child: Text(AppLocalizations.of(context)!.save),
        ),
      ],
    );
  }
}
