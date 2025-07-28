import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/media_provider.dart';
import '../models/media_file.dart';
import '../models/playlist.dart';
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _isLoading ? _buildLoadingScreen() : _buildMainContent(),
      floatingActionButton: widget.playlist != null && _playlistFiles.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _playAll,
              backgroundColor: Colors.blue,
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              label: const Text(
                'Play All',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Loading playlist...'),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        if (widget.playlist != null) _buildPlaylistInfo(),
        _buildFilesList(),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.blue,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.playlist?.name ?? 'Playlist',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.indigo],
            ),
          ),
        ),
      ),
      actions: [
        if (widget.playlist != null) ...[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _showAddMediaDialog,
            tooltip: 'Add Files',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit Playlist'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'shuffle',
                child: Row(
                  children: [
                    Icon(Icons.shuffle),
                    SizedBox(width: 8),
                    Text('Shuffle Play'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Delete Playlist',
                      style: TextStyle(color: Colors.red),
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

  Widget _buildPlaylistInfo() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1), // Fixed
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
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        if (widget.playlist!.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.playlist!.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
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
                    label: 'Total Files',
                    value: '${_playlistFiles.length}',
                    color: Colors.blue,
                  ),
                  _buildStatItem(
                    icon: Icons.music_note,
                    label: 'Audio',
                    value:
                        '${_playlistFiles.where((f) => f.type == 'audio').length}',
                    color: Colors.purple,
                  ),
                  _buildStatItem(
                    icon: Icons.video_library,
                    label: 'Video',
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

  Widget _buildFilesList() {
    if (_playlistFiles.isEmpty) {
      return SliverFillRemaining(child: _buildEmptyState());
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
                  ), // Fixed: Pass index as named parameter
                ),
              ),
            );
          }, childCount: _playlistFiles.length),
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
              color: Colors.grey.withValues(alpha: 0.1), // Fixed
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.playlist_add_rounded,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Playlist is Empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some files to get started',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (widget.playlist != null)
            ElevatedButton.icon(
              onPressed: _showAddMediaDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Files'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
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

  Widget _buildMediaListTile(MediaFile file, {int? index}) {
    // Fixed: Accept index as named parameter
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Hero(
          tag: 'file_${file.id}_${index ?? ''}', // Fixed: Use index in tag
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: file.type == 'audio'
                  ? Colors.purple.withValues(alpha: 0.1) // Fixed
                  : Colors.orange.withValues(alpha: 0.1), // Fixed
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
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${file.formattedDuration} • ${file.formattedSize}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            if (file.playCount > 0) ...[
              const SizedBox(height: 2),
              Text(
                'Played ${file.playCount} times',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
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
              onSelected: (value) => _handleFileAction(
                value,
                file,
                index ?? 0,
              ), // Fixed: Pass index
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
                      Icon(
                        file.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        file.isFavorite
                            ? 'Remove from Favorites'
                            : 'Add to Favorites',
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.remove_circle_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Remove from Playlist',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _playMediaFile(file, index ?? 0), // Fixed: Pass index
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
    showDialog(
      context: context,
      builder: (context) => _AddMediaDialog(
        playlist: widget.playlist!,
        onFilesAdded: _loadPlaylistFiles,
      ),
    );
  }

  void _handleMenuAction(String action) async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    switch (action) {
      case 'edit':
        final result = await showDialog<Map<String, String>>(
          context: context,
          builder: (context) => _EditPlaylistDialog(playlist: widget.playlist!),
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

  void _handleFileAction(String action, MediaFile file, int index) async {
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
            title: const Text('Remove from Playlist'),
            content: Text('Remove "${file.name}" from this playlist?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Remove'),
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
}

class _AddMediaDialog extends StatefulWidget {
  final Playlist playlist;
  final VoidCallback onFilesAdded;

  const _AddMediaDialog({required this.playlist, required this.onFilesAdded});

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
              'Add Files to ${widget.playlist.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search files...',
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
                      '${_selectedFiles.length} files selected',
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
                  ? const Center(child: Text('No files available to add'))
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
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _selectedFiles.isEmpty ? null : _addSelectedFiles,
                  child: Text('Add (${_selectedFiles.length})'),
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
        content: Text('Added ${_selectedFiles.length} files to playlist'),
        backgroundColor: Colors.green,
      ),
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
      title: const Text('Edit Playlist'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Playlist Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description (Optional)',
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
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'name': _nameController.text,
              'description': _descriptionController.text,
            });
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
