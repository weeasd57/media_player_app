import 'package:flutter/foundation.dart';
import '../models/media_file.dart';
import '../models/playlist.dart';
import '../services/database_service.dart';
import '../services/file_scanner_service.dart';

class MediaProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final FileScannerService _fileScannerService = FileScannerService();

  // Media files
  List<MediaFile> _allMediaFiles = [];
  List<MediaFile> _audioFiles = [];
  List<MediaFile> _videoFiles = [];
  List<MediaFile> _favoriteFiles = [];
  List<MediaFile> _recentFiles = [];

  // Playlists
  List<Playlist> _playlists = [];

  // Current playing
  MediaFile? _currentMediaFile;
  Playlist? _currentPlaylist;
  int _currentIndex = 0;

  // Loading states
  bool _isLoading = false;
  bool _isScanning = false;
  String _scanningStatus = '';

  // Statistics
  Map<String, int> _statistics = {};

  // Getters
  List<MediaFile> get allMediaFiles => _allMediaFiles;
  List<MediaFile> get audioFiles => _audioFiles;
  List<MediaFile> get videoFiles => _videoFiles;
  List<MediaFile> get favoriteFiles => _favoriteFiles;
  List<MediaFile> get recentFiles => _recentFiles;
  List<Playlist> get playlists => _playlists;
  
  MediaFile? get currentMediaFile => _currentMediaFile;
  Playlist? get currentPlaylist => _currentPlaylist;
  int get currentIndex => _currentIndex;
  
  bool get isLoading => _isLoading;
  bool get isScanning => _isScanning;
  String get scanningStatus => _scanningStatus;
  Map<String, int> get statistics => _statistics;

  // Initialize provider
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await loadAllData();
    } catch (e) {
      print('Error initializing MediaProvider: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load all data from database
  Future<void> loadAllData() async {
    await Future.wait([
      loadMediaFiles(),
      loadPlaylists(),
      loadStatistics(),
    ]);
  }

  // Load media files
  Future<void> loadMediaFiles() async {
    try {
      _allMediaFiles = await _databaseService.getAllMediaFiles();
      _audioFiles = await _databaseService.getMediaFilesByType('audio');
      _videoFiles = await _databaseService.getMediaFilesByType('video');
      _favoriteFiles = await _databaseService.getFavoriteMediaFiles();
      _recentFiles = await _databaseService.getRecentlyPlayedFiles();
      notifyListeners();
    } catch (e) {
      print('Error loading media files: $e');
    }
  }

  // Load playlists
  Future<void> loadPlaylists() async {
    try {
      _playlists = await _databaseService.getAllPlaylists();
      notifyListeners();
    } catch (e) {
      print('Error loading playlists: $e');
    }
  }

  // Load statistics
  Future<void> loadStatistics() async {
    try {
      _statistics = await _databaseService.getMediaStatistics();
      notifyListeners();
    } catch (e) {
      print('Error loading statistics: $e');
    }
  }

  // Scan for media files
  Future<ScanResult> scanForMediaFiles() async {
    _setScanning(true);
    try {
      final result = await _fileScannerService.performFullScan(
        onDirectoryChanged: (directory) {
          _scanningStatus = 'Scanning: $directory';
          notifyListeners();
        },
        onScanProgress: (current, total) {
          _scanningStatus = 'Scanning directories: $current/$total';
          notifyListeners();
        },
        onImportProgress: (current, total) {
          _scanningStatus = 'Importing files: $current/$total';
          notifyListeners();
        },
      );

      if (result.hasNewFiles) {
        await loadAllData();
      }

      return result;
    } catch (e) {
      print('Error scanning for media files: $e');
      return ScanResult(
        totalFilesFound: 0,
        filesAdded: 0,
        addedFiles: [],
        error: e.toString(),
      );
    } finally {
      _setScanning(false);
    }
  }

  // Add media file
  Future<MediaFile?> addMediaFile(MediaFile mediaFile) async {
    try {
      final id = await _databaseService.insertMediaFile(mediaFile);
      final newFile = mediaFile.copyWith(id: id);
      await loadMediaFiles();
      await loadStatistics();
      return newFile;
    } catch (e) {
      print('Error adding media file: $e');
      return null;
    }
  }

  // Update media file
  Future<bool> updateMediaFile(MediaFile mediaFile) async {
    try {
      await _databaseService.updateMediaFile(mediaFile);
      await loadMediaFiles();
      return true;
    } catch (e) {
      print('Error updating media file: $e');
      return false;
    }
  }

  // Delete media file
  Future<bool> deleteMediaFile(int id) async {
    try {
      await _databaseService.deleteMediaFile(id);
      await loadMediaFiles();
      await loadStatistics();
      return true;
    } catch (e) {
      print('Error deleting media file: $e');
      return false;
    }
  }

  // Toggle favorite
  Future<void> toggleFavorite(int id) async {
    try {
      await _databaseService.toggleFavorite(id);
      await loadMediaFiles();
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  // Update play count
  Future<void> updatePlayCount(int id) async {
    try {
      await _databaseService.updatePlayCount(id);
      await loadMediaFiles();
    } catch (e) {
      print('Error updating play count: $e');
    }
  }

  // Create playlist
  Future<Playlist?> createPlaylist(String name, {String description = ''}) async {
    try {
      final playlist = Playlist(
        name: name,
        description: description,
        dateCreated: DateTime.now(),
        lastModified: DateTime.now(),
      );
      
      final id = await _databaseService.insertPlaylist(playlist);
      final newPlaylist = playlist.copyWith(id: id);
      await loadPlaylists();
      await loadStatistics();
      return newPlaylist;
    } catch (e) {
      print('Error creating playlist: $e');
      return null;
    }
  }

  // Update playlist
  Future<bool> updatePlaylist(Playlist playlist) async {
    try {
      await _databaseService.updatePlaylist(playlist);
      await loadPlaylists();
      return true;
    } catch (e) {
      print('Error updating playlist: $e');
      return false;
    }
  }

  // Delete playlist
  Future<bool> deletePlaylist(int id) async {
    try {
      await _databaseService.deletePlaylist(id);
      await loadPlaylists();
      await loadStatistics();
      return true;
    } catch (e) {
      print('Error deleting playlist: $e');
      return false;
    }
  }

  // Add media file to playlist
  Future<bool> addToPlaylist(int playlistId, int mediaFileId) async {
    try {
      final playlist = await _databaseService.getPlaylistById(playlistId);
      if (playlist != null) {
        final updatedIds = List<int>.from(playlist.mediaFileIds);
        if (!updatedIds.contains(mediaFileId)) {
          updatedIds.add(mediaFileId);
          final updatedPlaylist = playlist.copyWith(
            mediaFileIds: updatedIds,
            lastModified: DateTime.now(),
          );
          await _databaseService.updatePlaylist(updatedPlaylist);
          await loadPlaylists();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error adding to playlist: $e');
      return false;
    }
  }

  // Remove media file from playlist
  Future<bool> removeFromPlaylist(int playlistId, int mediaFileId) async {
    try {
      final playlist = await _databaseService.getPlaylistById(playlistId);
      if (playlist != null) {
        final updatedIds = List<int>.from(playlist.mediaFileIds);
        updatedIds.remove(mediaFileId);
        final updatedPlaylist = playlist.copyWith(
          mediaFileIds: updatedIds,
          lastModified: DateTime.now(),
        );
        await _databaseService.updatePlaylist(updatedPlaylist);
        await loadPlaylists();
        return true;
      }
      return false;
    } catch (e) {
      print('Error removing from playlist: $e');
      return false;
    }
  }

  // Get playlist media files
  Future<List<MediaFile>> getPlaylistMediaFiles(int playlistId) async {
    try {
      return await _databaseService.getPlaylistMediaFiles(playlistId);
    } catch (e) {
      print('Error getting playlist media files: $e');
      return [];
    }
  }

  // Search media files
  Future<List<MediaFile>> searchMediaFiles(String query) async {
    try {
      return await _databaseService.searchMediaFiles(query);
    } catch (e) {
      print('Error searching media files: $e');
      return [];
    }
  }

  // Search playlists
  Future<List<Playlist>> searchPlaylists(String query) async {
    try {
      return await _databaseService.searchPlaylists(query);
    } catch (e) {
      print('Error searching playlists: $e');
      return [];
    }
  }

  // Set current media file
  void setCurrentMediaFile(MediaFile? mediaFile, {int index = 0}) {
    _currentMediaFile = mediaFile;
    _currentIndex = index;
    notifyListeners();
    
    // Update play count if media file is set
    if (mediaFile != null) {
      updatePlayCount(mediaFile.id!);
    }
  }

  // Set current playlist
  void setCurrentPlaylist(Playlist? playlist) {
    _currentPlaylist = playlist;
    notifyListeners();
  }

  // Play next in current playlist
  Future<MediaFile?> playNext() async {
    if (_currentPlaylist != null) {
      final playlistFiles = await getPlaylistMediaFiles(_currentPlaylist!.id!);
      if (playlistFiles.isNotEmpty && _currentIndex < playlistFiles.length - 1) {
        _currentIndex++;
        _currentMediaFile = playlistFiles[_currentIndex];
        notifyListeners();
        updatePlayCount(_currentMediaFile!.id!);
        return _currentMediaFile;
      }
    }
    return null;
  }

  // Play previous in current playlist
  Future<MediaFile?> playPrevious() async {
    if (_currentPlaylist != null) {
      final playlistFiles = await getPlaylistMediaFiles(_currentPlaylist!.id!);
      if (playlistFiles.isNotEmpty && _currentIndex > 0) {
        _currentIndex--;
        _currentMediaFile = playlistFiles[_currentIndex];
        notifyListeners();
        updatePlayCount(_currentMediaFile!.id!);
        return _currentMediaFile;
      }
    }
    return null;
  }

  // Cleanup missing files
  Future<int> cleanupMissingFiles() async {
    try {
      final removedCount = await _fileScannerService.cleanupMissingFiles();
      if (removedCount > 0) {
        await loadAllData();
      }
      return removedCount;
    } catch (e) {
      print('Error cleaning up missing files: $e');
      return 0;
    }
  }

  // Clear all data
  Future<void> clearAllData() async {
    try {
      await _databaseService.clearAllData();
      await loadAllData();
    } catch (e) {
      print('Error clearing all data: $e');
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setScanning(bool scanning) {
    _isScanning = scanning;
    if (!scanning) {
      _scanningStatus = '';
    }
    notifyListeners();
  }
}