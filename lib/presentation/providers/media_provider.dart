import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/media_file.dart';
import '../../data/models/playlist.dart';
import '../../data/datasources/database_service.dart';
import '../../data/datasources/file_scanner_service.dart';
import 'package:flutter/foundation.dart';

class MediaProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final FileScannerService _fileScannerService = FileScannerService();

  List<MediaFile> _allMediaFiles = [];
  List<MediaFile> _recentFiles = [];
  List<MediaFile> _favoriteFiles = [];
  List<Playlist> _playlists = [];
  Map<String, int> _statistics = {};
  bool _isScanning = false;
  String _scanningStatus = '';

  Playlist? _currentPlaylist;
  MediaFile? _currentMediaFile;

  bool _autoRepeat = false;
  bool _shuffleMode = false;

  List<MediaFile> get allMediaFiles => _allMediaFiles;
  List<MediaFile> get recentFiles => _recentFiles;
  List<MediaFile> get favoriteFiles => _favoriteFiles;
  List<Playlist> get playlists => _playlists;
  Map<String, int> get statistics => _statistics;
  bool get isScanning => _isScanning;
  String get scanningStatus => _scanningStatus;

  Playlist? get currentPlaylist => _currentPlaylist;
  MediaFile? get currentMediaFile => _currentMediaFile;

  bool get autoRepeat => _autoRepeat;
  bool get shuffleMode => _shuffleMode;

  Future<void> initialize() async {
    await _databaseService.database;
    debugPrint('MediaProvider initialized: Database and media loaded.');
    await _loadMediaFiles();
    await _loadPlaylists();
    await _loadSettings();
  }

  Future<void> _loadMediaFiles() async {
    _allMediaFiles = await _databaseService.getAllMediaFiles();
    // Get all files and sort them by lastPlayed
    _recentFiles = _allMediaFiles.toList();
    _recentFiles.sort((a, b) => b.lastPlayed.compareTo(a.lastPlayed));
    _favoriteFiles = _allMediaFiles.where((file) => file.isFavorite).toList();
    _updateStatistics();
    notifyListeners();
  }

  Future<void> _loadPlaylists() async {
    _playlists = await _databaseService.getAllPlaylists();
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _autoRepeat = prefs.getBool('autoRepeat') ?? false;
    _shuffleMode = prefs.getBool('shuffleMode') ?? false;
    notifyListeners();
  }

  void _updateStatistics() {
    _statistics = {
      'audio': _allMediaFiles.where((file) => file.type == 'audio').length,
      'video': _allMediaFiles.where((file) => file.type == 'video').length,
      'favorites': _favoriteFiles.length,
      'playlists': _playlists.length,
    };
    debugPrint('Statistics updated: $_statistics');
  }

  Future<void> scanForMediaFiles() async {
    _isScanning = true;
    _scanningStatus = 'Preparing to scan...';
    notifyListeners();
    debugPrint('Starting media scan...');

    try {
      final scanResult = await _fileScannerService.performFullScan(
        onDirectoryChanged: (status) {
          _scanningStatus = status;
          debugPrint('Scanning status: $status');
          notifyListeners();
        },
      );

      if (!scanResult.hasError) {
        await _loadMediaFiles();
        _scanningStatus = 'Scan complete!';
        debugPrint('Scan complete. Found ${scanResult.filesAdded} new files.');
      } else {
        _scanningStatus = 'Scan error: ${scanResult.error}';
        debugPrint('Scan error: ${scanResult.error}');
      }
      notifyListeners();
      return;
    } catch (e) {
      _scanningStatus = 'Scan error: $e';
      debugPrint('Scan error: $e');
      notifyListeners();
      return;
    } finally {
      _isScanning = false;
      debugPrint('Media scan finished.');
      notifyListeners();
    }
  }

  Future<bool> checkAndRequestPermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<void> scanAllFiles() async {
    await scanForMediaFiles();
  }

  Future<void> updateMediaFile(MediaFile file) async {
    await _databaseService.updateMediaFile(file);
    await _loadMediaFiles();
  }

  Future<void> toggleFavorite(MediaFile file) async {
    final updatedFile = file.copyWith(isFavorite: !file.isFavorite);
    await _databaseService.updateMediaFile(updatedFile);
    await _loadMediaFiles();
  }

  Future<void> createPlaylist(String name, {String description = ''}) async {
    final newPlaylist = Playlist(
      id: null,
      name: name,
      description: description, // Pass description
      dateCreated: DateTime.now(),
      lastModified: DateTime.now(),
      mediaFileIds: [],
    );
    final id = await _databaseService.insertPlaylist(newPlaylist);
    _playlists.add(newPlaylist.copyWith(id: id));
    _updateStatistics();
    notifyListeners();
  }

  Future<void> addMediaToPlaylist(
    Playlist playlist,
    MediaFile mediaFile,
  ) async {
    if (mediaFile.id != null && !playlist.mediaFileIds.contains(mediaFile.id)) {
      final updatedMediaIds = List<int>.from(playlist.mediaFileIds)
        ..add(mediaFile.id!);
      final updatedPlaylist = playlist.copyWith(mediaFileIds: updatedMediaIds);
      await _databaseService.updatePlaylist(updatedPlaylist);
      _loadPlaylists();
      notifyListeners();
    }
  }

  Future<void> removeMediaFromPlaylist(
    Playlist playlist,
    MediaFile mediaFile,
  ) async {
    if (mediaFile.id != null) {
      final updatedMediaIds = List<int>.from(playlist.mediaFileIds)
        ..remove(mediaFile.id);
      final updatedPlaylist = playlist.copyWith(mediaFileIds: updatedMediaIds);
      await _databaseService.updatePlaylist(updatedPlaylist);
      _loadPlaylists();
      notifyListeners();
    }
  }

  Future<void> deletePlaylist(Playlist playlist) async {
    await _databaseService.deletePlaylist(playlist.id!);
    _playlists.removeWhere((p) => p.id == playlist.id);
    _updateStatistics();
    notifyListeners();
  }

  Future<void> cleanLibrary() async {
    debugPrint('Starting library clean up...');
    final removedCount = await _fileScannerService.cleanupMissingFiles();
    debugPrint('Removed $removedCount missing files.');
    await _loadMediaFiles();
    _updateStatistics();
    debugPrint('Library clean up complete.');
    notifyListeners();
  }

  // إضافة الطريقة المفقودة
  Future<void> cleanupMissingFiles() async {
    await cleanLibrary();
  }

  Future<List<MediaFile>> searchMediaFiles(String query) async {
    if (query.isEmpty) {
      return _allMediaFiles;
    }
    return _allMediaFiles
        .where((file) => file.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void setCurrentPlaylist(Playlist? playlist) {
    _currentPlaylist = playlist;
    notifyListeners();
  }

  void setCurrentMediaFile(MediaFile? mediaFile) {
    _currentMediaFile = mediaFile;
    notifyListeners();
  }

  Future<void> setAutoRepeat(bool value) async {
    _autoRepeat = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoRepeat', value);
    notifyListeners();
  }

  Future<void> setShuffleMode(bool value) async {
    _shuffleMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('shuffleMode', value);
    notifyListeners();
  }

  Future<List<MediaFile>> getMediaFilesByType(String type) async {
    return await _databaseService.getMediaFilesByType(type);
  }

  Future<void> deleteMediaFile(MediaFile file) async {
    if (file.id != null) {
      await _databaseService.deleteMediaFile(file.id!);
      for (var playlist in _playlists) {
        if (playlist.mediaFileIds.contains(file.id)) {
          final updatedMediaIds = List<int>.from(playlist.mediaFileIds)
            ..remove(file.id);
          final updatedPlaylist = playlist.copyWith(
            mediaFileIds: updatedMediaIds,
          );
          await _databaseService.updatePlaylist(updatedPlaylist);
        }
      }
      await _loadMediaFiles();
      await _loadPlaylists();
    }
  }

  Future<List<MediaFile>> getPlaylistMediaFiles(int playlistId) async {
    return await _databaseService.getPlaylistMediaFiles(playlistId);
  }

  Future<void> updatePlaylist(Playlist playlist) async {
    await _databaseService.updatePlaylist(playlist);
    _loadPlaylists();
    notifyListeners();
  }

  Future<void> addToPlaylist(Playlist playlist, MediaFile mediaFile) async {
    await addMediaToPlaylist(playlist, mediaFile);
  }

  Future<void> removeFromPlaylist(
    Playlist playlist,
    MediaFile mediaFile,
  ) async {
    await removeMediaFromPlaylist(playlist, mediaFile);
  }

  Future<void> clearAllData() async {
    await _databaseService.clearAllData();
    _allMediaFiles.clear();
    _recentFiles.clear();
    _favoriteFiles.clear();
    _playlists.clear();
    _statistics.clear();
    await _loadSettings();
    notifyListeners();
  }

  // New: updatePlayCount method
  Future<void> updatePlayCount(int mediaFileId) async {
    await _databaseService.updatePlayCount(mediaFileId);
    await _loadMediaFiles(); // Reload to update UI with new play count
  }
}

class ScanResult {
  final int filesAdded;
  final int totalFilesFound;
  final bool hasError;
  final String? error;

  ScanResult({
    this.filesAdded = 0,
    this.totalFilesFound = 0,
    required this.hasError,
    this.error,
  });
}
