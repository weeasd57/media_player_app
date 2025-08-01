import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/media_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/text_provider.dart';
import '../../data/models/media_file.dart';
import 'audio_player_screen.dart';
import 'video_player_screen.dart';
import 'package:media_player_app/services/media_playback_service.dart';
import 'dart:io'; // Required for Directory and File operations
import 'package:path_provider/path_provider.dart'; // For getting common directories
import 'package:path/path.dart' as p; // For path manipulation
// import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Removed as TextProvider handles localization

enum ViewMode { list, grid }

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
  // New: Search functionality
  late TextEditingController _searchController;
  String _searchQuery = '';
  ViewMode _viewMode = ViewMode.list; // New: Default view mode

  Directory? _currentDirectory; // New: To keep track of the current directory
  List<FileSystemEntity> _folderContents =
      []; // New: To store contents of the current directory
  bool _isFoldersLoading = true; // New: Loading state for folders tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // New: Initialize search controller
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);

    // Load initial directory for folders tab
    _loadInitialDirectory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    // New: Dispose search controller
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // New: Search change listener
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  // New: Filter files method
  List<MediaFile> _filterFiles(List<MediaFile> files, {String? fileType}) {
    List<MediaFile> filteredList = files;

    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList.where((file) {
        return file.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (file.artist?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
                false) ||
            (file.album?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
                false);
      }).toList();
    }

    if (fileType != null) {
      filteredList = filteredList
          .where((file) => file.type == fileType)
          .toList();
    }

    return filteredList;
  }

  // New: Function to load initial directory
  Future<void> _loadInitialDirectory() async {
    // Get external storage directory for Android, or documents directory for iOS/Desktop
    Directory? initialDir;
    if (Platform.isAndroid) {
      initialDir = await getExternalStorageDirectory();
    } else if (Platform.isIOS ||
        Platform.isWindows ||
        Platform.isLinux ||
        Platform.isMacOS) {
      initialDir = await getApplicationDocumentsDirectory();
    }

    if (initialDir != null) {
      _currentDirectory = initialDir;
      await _loadDirectoryContents(
        _currentDirectory!,
      ); // Load contents of the initial directory
    }
    if (!mounted) return; // Add this line to ensure the widget is still mounted
    setState(() {
      _isFoldersLoading = false;
    });
  }

  // New: Function to load directory contents
  Future<void> _loadDirectoryContents(Directory directory) async {
    setState(() {
      _isFoldersLoading = true;
    });
    try {
      final contents = await directory.list().toList();
      if (!mounted) return; // Add this line
      _folderContents = contents
          .where(
            (entity) =>
                entity is Directory ||
                (entity is File &&
                    (entity.path.endsWith('.mp3') ||
                        entity.path.endsWith('.wav') ||
                        entity.path.endsWith('.m4a') ||
                        entity.path.endsWith('.mp4') ||
                        entity.path.endsWith('.avi') ||
                        entity.path.endsWith('.mov'))),
          )
          .toList();
      _folderContents.sort((a, b) {
        if (a is Directory && b is! Directory) return -1; // Directories first
        if (a is! Directory && b is Directory) return 1;
        return p
            .basename(a.path)
            .toLowerCase()
            .compareTo(p.basename(b.path).toLowerCase());
      });
    } catch (e) {
      debugPrint('Error loading directory: $e');
      _folderContents = [];
      // Show an error message to the user
      if (!mounted) return; // Add this line
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading folder: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
    if (!mounted) return; // Add this line
    setState(() {
      _isFoldersLoading = false;
    });
  }

  // New: Function to navigate up in directory tree
  Future<void> _goUpDirectory() async {
    if (_currentDirectory != null &&
        _currentDirectory!.parent.path != _currentDirectory!.path) {
      _currentDirectory = _currentDirectory!.parent;
      await _loadDirectoryContents(_currentDirectory!);
    }
  }

  // New: Function to handle folder tap
  void _onFolderTap(Directory directory) async {
    _currentDirectory = directory;
    await _loadDirectoryContents(_currentDirectory!);
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
              IconButton(
                icon: Icon(
                  _viewMode == ViewMode.list ? Icons.grid_view : Icons.list,
                ),
                onPressed: () {
                  setState(() {
                    _viewMode = _viewMode == ViewMode.list
                        ? ViewMode.grid
                        : ViewMode.list;
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
                        Text(textProvider.getText('sortByName')),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'date',
                    child: Row(
                      children: [
                        const Icon(Icons.access_time),
                        const SizedBox(width: 8),
                        Text(textProvider.getText('sortByDate')),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'size',
                    child: Row(
                      children: [
                        const Icon(Icons.storage),
                        const SizedBox(width: 8),
                        Text(textProvider.getText('sortBySize')),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(
                100.0,
              ), // Adjust height as needed
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: textProvider.getText('search'),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHigh,
                      ),
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    labelColor: colorScheme.primary,
                    unselectedLabelColor: colorScheme.onSurface.withValues(
                      alpha: 0.6,
                    ),
                    indicatorColor: colorScheme.primary,
                    tabs: [
                      Tab(text: textProvider.getText('allFiles')),
                      Tab(text: textProvider.getText('audioFiles')),
                      Tab(text: textProvider.getText('videoFiles')),
                      Tab(text: textProvider.getText('folders')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildAllFilesTab(themeProvider, textProvider),
              _buildAudioTab(themeProvider, textProvider),
              _buildVideoTab(themeProvider, textProvider),
              _buildFoldersTab(themeProvider, textProvider),
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
        final files = _filterFiles(
          _sortFiles(mediaProvider.allMediaFiles),
          fileType: null,
        );

        if (files.isEmpty) {
          String emptyMessage = _searchQuery.isNotEmpty
              ? textProvider.getText('noSearchResults')
              : textProvider.getText('noFilesFound');
          return _buildEmptyState(
            emptyMessage,
            Icons.library_music,
            themeProvider,
            textProvider,
          );
        }

        // New: Conditional rendering based on view mode
        if (_viewMode == ViewMode.list) {
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
        } else {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  2, // You can adjust this for different screen sizes
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8, // Adjust as needed
            ),
            itemCount: files.length,
            itemBuilder: (context, index) {
              return _buildMediaGridTile(
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
                themeProvider,
                textProvider,
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              String emptyMessage = _searchQuery.isNotEmpty
                  ? textProvider.getText('noSearchResults')
                  : textProvider.getText('noFilesFound');
              return _buildEmptyState(
                emptyMessage,
                Icons.music_note,
                themeProvider,
                textProvider,
              );
            } else {
              final files = _filterFiles(
                _sortFiles(snapshot.data!),
                fileType: 'audio',
              );
              // New: Conditional rendering based on view mode
              if (_viewMode == ViewMode.list) {
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
              } else {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    return _buildMediaGridTile(
                      files[index],
                      index,
                      themeProvider,
                      textProvider,
                    );
                  },
                );
              }
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
                themeProvider,
                textProvider,
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              String emptyMessage = _searchQuery.isNotEmpty
                  ? textProvider.getText('noSearchResults')
                  : textProvider.getText('noFilesFound');
              return _buildEmptyState(
                emptyMessage,
                Icons.video_library,
                themeProvider,
                textProvider,
              );
            } else {
              final files = _filterFiles(
                _sortFiles(snapshot.data!),
                fileType: 'video',
              );
              // New: Conditional rendering based on view mode
              if (_viewMode == ViewMode.list) {
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
              } else {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    return _buildMediaGridTile(
                      files[index],
                      index,
                      themeProvider,
                      textProvider,
                    );
                  },
                );
              }
            }
          },
        );
      },
    );
  }

  Widget _buildEmptyState(
    String message,
    IconData icon,
    ThemeProvider themeProvider,
    TextProvider textProvider,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: themeProvider.iconColor),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: themeProvider.primaryTextColor.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _scanForFiles,
            icon: const Icon(Icons.refresh),
            label: Text(textProvider.getText('scanFiles')),
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
                textProvider.getTextWithParams('playedTimes', {
                  'count': file.playCount,
                }),
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
              onSelected: (value) =>
                  _handleFileAction(value, file, textProvider),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'play',
                  enabled: !file.isMissing, // Disable if file is missing
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
                  enabled: !file.isMissing, // Disable if file is missing
                  child: Row(
                    children: [
                      const Icon(Icons.playlist_add),
                      const SizedBox(width: 8),
                      Text(textProvider.getText('addToPlaylist')),
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
                        textProvider.getText('delete'),
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
            ? _showMissingFileMessage(file.name, textProvider)
            : _playMediaFile(file),
      ),
    );
  }

  Widget _buildMediaGridTile(
    MediaFile file,
    int index,
    ThemeProvider themeProvider,
    TextProvider textProvider,
  ) {
    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => file.isMissing
            ? _showMissingFileMessage(file.name, textProvider)
            : _playMediaFile(file),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'media_${file.id}',
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: file.type == 'audio'
                      ? themeProvider.currentTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                      : themeProvider.currentTheme.colorScheme.secondary
                            .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
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
                          ? themeProvider.secondaryTextColor.withValues(
                              alpha: 0.6,
                            )
                          : themeProvider.primaryTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    file.formattedDuration,
                    style: TextStyle(
                      color: file.isMissing
                          ? themeProvider.secondaryTextColor.withValues(
                              alpha: 0.4,
                            )
                          : themeProvider.secondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
                  if (file.isMissing)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Icon(
                        Icons.cloud_off_rounded,
                        size: 16,
                        color: themeProvider.currentTheme.colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
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
    final mediaPlaybackService = Provider.of<MediaPlaybackService>(
      context,
      listen: false,
    );
    mediaProvider.setCurrentMediaFile(file);
    mediaPlaybackService.playMedia(file);

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
          backgroundColor: themeProvider.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            textProvider.getText('delete'),
            style: TextStyle(color: themeProvider.primaryTextColor),
          ),
          content: Text(
            textProvider.getTextWithParams('deletePlaylistConfirmation', {
              'playlistName': file.name,
            }),
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
                final errorColor = themeProvider.currentTheme.colorScheme.error;

                final mediaProvider = Provider.of<MediaProvider>(
                  context,
                  listen: false,
                );
                await mediaProvider.deleteMediaFile(file);
                if (!mounted) return;

                navigator.pop();
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text(textProvider.getText('success')),
                    backgroundColor: errorColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.currentTheme.colorScheme.error,
              ),
              child: Text(
                textProvider.getText('delete'),
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

  void _scanForFiles() async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    final textProvider = Provider.of<TextProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    if (mediaProvider.isScanning) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.refresh_rounded,
              color: themeProvider.currentTheme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Text(
              textProvider.getText('scanningFiles'),
              style: TextStyle(color: themeProvider.primaryTextColor),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: themeProvider.currentTheme.colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Consumer<MediaProvider>(
              builder: (context, provider, child) {
                return Text(
                  provider.scanningStatus.isNotEmpty
                      ? provider.scanningStatus
                      : textProvider.getText('loading'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: themeProvider.primaryTextColor),
                );
              },
            ),
          ],
        ),
      ),
    );

    // بدء عملية المسح
    await mediaProvider.scanForMediaFiles();

    // إغلاق الحوار بعد انتهاء المسح
    if (mounted) {
      Navigator.of(context).pop();

      // إظهار رسالة نجاح المسح
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: themeProvider.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 12),
              Text(
                textProvider.getText('scanComplete'),
                style: TextStyle(color: themeProvider.primaryTextColor),
              ),
            ],
          ),
          content: Text(
            textProvider.getText('scanCompleteMessage'),
            style: TextStyle(color: themeProvider.secondaryTextColor),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.currentTheme.colorScheme.primary,
                foregroundColor:
                    themeProvider.currentTheme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(textProvider.getText('ok')),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildFoldersTab(
    ThemeProvider themeProvider,
    TextProvider textProvider,
  ) {
    if (_isFoldersLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filter folders and files based on search query
    final filteredContents = _folderContents.where((entity) {
      final name = p.basename(entity.path).toLowerCase();
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    if (filteredContents.isEmpty) {
      return _buildEmptyState(
        _searchQuery.isNotEmpty
            ? textProvider.getText('noSearchResults')
            : textProvider.getText('noFilesFound'),
        Icons.folder_off,
        themeProvider,
        textProvider,
      );
    }

    return Column(
      children: [
        if (_currentDirectory!.path !=
            p.rootPrefix(p.current)) // Show back button if not at root
          ListTile(
            leading: const Icon(Icons.arrow_back, color: Colors.blueGrey),
            title: Text(
              textProvider.getText('parentDirectory'), // 'Parent Directory'
              style: TextStyle(
                color: themeProvider.primaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: _goUpDirectory,
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredContents.length,
            itemBuilder: (context, index) {
              final entity = filteredContents[index];
              if (entity is Directory) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: 1,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.folder,
                      color: themeProvider.currentTheme.colorScheme.primary,
                    ),
                    title: Text(
                      p.basename(entity.path),
                      style: TextStyle(color: themeProvider.primaryTextColor),
                    ),
                    onTap: () => _onFolderTap(entity),
                  ),
                );
              } else if (entity is File) {
                // Display media files similar to other tabs
                return _buildMediaListTile(
                  MediaFile(
                    // Create a dummy MediaFile for display
                    id: null,
                    name: p.basenameWithoutExtension(entity.path),
                    path: entity.path,
                    type:
                        (entity.path.endsWith('.mp3') ||
                            entity.path.endsWith('.wav') ||
                            entity.path.endsWith('.m4a'))
                        ? 'audio'
                        : 'video',
                    duration: 0,
                    size: 0,
                    dateAdded: DateTime.fromMillisecondsSinceEpoch(
                      DateTime.now().millisecondsSinceEpoch,
                    ),
                    lastPlayed: DateTime.fromMillisecondsSinceEpoch(
                      DateTime.now().millisecondsSinceEpoch,
                    ),
                    playCount: 0,
                    isFavorite: false,
                    isMissing: false,
                  ),
                  index, // Pass index
                  themeProvider,
                  textProvider,
                );
              }
              return const SizedBox.shrink(); // Fallback for unsupported types
            },
          ),
        ),
      ],
    );
  }

  void _showMissingFileMessage(String fileName, TextProvider textProvider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          textProvider.getTextWithParams('fileNotFound', {
            'fileName': fileName,
          }),
        ),
        backgroundColor: Colors.red,
      ),
    );
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
          backgroundColor: themeProvider.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            textProvider.getText('addToPlaylist'),
            style: TextStyle(color: themeProvider.primaryTextColor),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: mediaProvider.playlists.isEmpty
                ? Center(
                    child: Text(
                      textProvider.getText('emptyPlaylist'),
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
                          style: TextStyle(
                            color: themeProvider.primaryTextColor,
                          ),
                        ),
                        subtitle: Text(
                          textProvider.getTextWithParams('filesSelected', {
                            'count': playlist.mediaCount,
                          }), // Using textProvider.getTextWithParams
                          style: TextStyle(
                            color: themeProvider.secondaryTextColor,
                          ),
                        ),
                        onTap: () async {
                          final navigator = Navigator.of(context);
                          final scaffold = ScaffoldMessenger.of(context);

                          await mediaProvider.addToPlaylist(playlist, file);

                          navigator.pop();
                          scaffold.showSnackBar(
                            SnackBar(
                              content: Text(
                                textProvider.getTextWithParams(
                                  'addedToPlaylist',
                                  {'name': playlist.name},
                                ), // Using textProvider.getTextWithParams
                              ),
                              backgroundColor: themeProvider
                                  .currentTheme
                                  .colorScheme
                                  .primary, // Using primary color for consistency
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
              child: Text(
                textProvider.getText('cancel'),
                style: TextStyle(
                  color: themeProvider.currentTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
