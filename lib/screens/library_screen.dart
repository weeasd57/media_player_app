import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/media_provider.dart';
import '../models/media_file.dart';
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Library',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleSort,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'name',
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha),
                    SizedBox(width: 8),
                    Text('Sort by Name'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'date',
                child: Row(
                  children: [
                    Icon(Icons.access_time),
                    SizedBox(width: 8),
                    Text('Sort by Date'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'size',
                child: Row(
                  children: [
                    Icon(Icons.storage),
                    SizedBox(width: 8),
                    Text('Sort by Size'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'All Files'),
            Tab(text: 'Audio'),
            Tab(text: 'Video'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllFilesTab(),
          _buildAudioTab(),
          _buildVideoTab(),
        ],
      ),
    );
  }

  Widget _buildAllFilesTab() {
    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        final files = _sortFiles(mediaProvider.allMediaFiles);
        
        if (files.isEmpty) {
          return _buildEmptyState('No media files found', Icons.library_music);
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: files.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildMediaListTile(files[index], index),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAudioTab() {
    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        final files = _sortFiles(mediaProvider.audioFiles);
        
        if (files.isEmpty) {
          return _buildEmptyState('No audio files found', Icons.music_note);
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: files.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildMediaListTile(files[index], index),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildVideoTab() {
    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        final files = _sortFiles(mediaProvider.videoFiles);
        
        if (files.isEmpty) {
          return _buildEmptyState('No video files found', Icons.video_library);
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: files.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildMediaListTile(files[index], index),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _scanForFiles,
            icon: const Icon(Icons.refresh),
            label: const Text('Scan for Files'),
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

  Widget _buildMediaListTile(MediaFile file, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
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
                  ? Colors.purple.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
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
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
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
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            if (file.playCount > 0) ...[
              const SizedBox(height: 2),
              Text(
                'Played ${file.playCount} times',
                style: TextStyle(
                  color: Colors.grey[500],
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
              const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 20,
              ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) => _handleFileAction(value, file),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'play',
                  child: Row(
                    children: [
                      Icon(Icons.play_arrow),
                      SizedBox(width: 8),
                      Text('Play'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'favorite',
                  child: Row(
                    children: [
                      Icon(file.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border),
                      const SizedBox(width: 8),
                      Text(file.isFavorite
                          ? 'Remove from Favorites'
                          : 'Add to Favorites'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'addToPlaylist',
                  child: Row(
                    children: [
                      Icon(Icons.playlist_add),
                      SizedBox(width: 8),
                      Text('Add to Playlist'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
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
        sortedFiles.sort((a, b) => _isAscending
            ? a.name.compareTo(b.name)
            : b.name.compareTo(a.name));
        break;
      case 'date':
        sortedFiles.sort((a, b) => _isAscending
            ? a.dateAdded.compareTo(b.dateAdded)
            : b.dateAdded.compareTo(a.dateAdded));
        break;
      case 'size':
        sortedFiles.sort((a, b) => _isAscending
            ? a.size.compareTo(b.size)
            : b.size.compareTo(a.size));
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
    
    if (file.type == 'audio') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AudioPlayerScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const VideoPlayerScreen(),
        ),
      );
    }
  }

  void _handleFileAction(String action, MediaFile file) async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    
    switch (action) {
      case 'play':
        _playMediaFile(file);
        break;
        
      case 'favorite':
        await mediaProvider.toggleFavorite(file.id!);
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
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete File'),
        content: Text('Are you sure you want to delete "${file.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
              await mediaProvider.deleteMediaFile(file.id!);
              if (mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('File deleted successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _scanForFiles() async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    final result = await mediaProvider.scanForMediaFiles();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.hasError
                ? 'Scan error: ${result.error}'
                : 'Found ${result.totalFilesFound} files, added ${result.filesAdded} new files',
          ),
          backgroundColor: result.hasError ? Colors.red : Colors.green,
        ),
      );
    }
  }
}

class _AddToPlaylistDialog extends StatelessWidget {
  final MediaFile file;

  const _AddToPlaylistDialog({required this.file});

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add to Playlist'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: mediaProvider.playlists.isEmpty
                ? const Center(
                    child: Text('No playlists available'),
                  )
                : ListView.builder(
                    itemCount: mediaProvider.playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = mediaProvider.playlists[index];
                      return ListTile(
                        leading: const Icon(Icons.playlist_play),
                        title: Text(playlist.name),
                        subtitle: Text('${playlist.mediaCount} files'),
                        onTap: () async {
                          await mediaProvider.addToPlaylist(playlist.id!, file.id!);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added to ${playlist.name}'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}