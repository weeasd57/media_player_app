import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/media_file.dart';
import '../../data/models/playlist.dart';
import '../../data/datasources/database_service.dart';
import '../../data/datasources/file_scanner_service.dart';
import 'package:flutter/foundation.dart';
import 'dart:io'; // Added for File.exists()
import 'package:path/path.dart' as p; // Import path package

class MediaProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final FileScannerService _fileScannerService = FileScannerService();

  List<MediaFile> _allMediaFiles = [];
  List<MediaFile> _recentFiles = [];
  List<MediaFile> _favoriteFiles = [];
  List<MediaFile> _missingFiles = []; // New: List to hold missing files
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
  List<MediaFile> get missingFiles => _missingFiles; // New getter
  List<Playlist> get playlists => _playlists;
  
  // إضافة خصائص audioFiles و videoFiles
  List<MediaFile> get audioFiles => _allMediaFiles.where((file) => file.type == 'audio').toList();
  List<MediaFile> get videoFiles => _allMediaFiles.where((file) => file.type == 'video').toList();
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
    final allFilesFromDb = await _databaseService.getAllMediaFiles();

    _allMediaFiles = allFilesFromDb.where((file) => !file.isMissing).toList();
    _missingFiles = allFilesFromDb.where((file) => file.isMissing).toList();

    // إذا كانت قاعدة البيانات فارغة، قم بتحميل الملفات التجريبية
    if (_allMediaFiles.isEmpty && _missingFiles.isEmpty) {
      await _loadSampleMedia();
    } else {
      // Get all files and sort them by lastPlayed
      _recentFiles = _allMediaFiles.toList();
      _recentFiles.sort((a, b) => b.lastPlayed.compareTo(a.lastPlayed));
      _favoriteFiles = _allMediaFiles.where((file) => file.isFavorite).toList();
    }

    _updateStatistics();
    notifyListeners();
  }

  Future<void> _loadSampleMedia() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final sampleMediaPaths = manifestMap.keys
        .where((String key) => key.contains('assets/sample_media/'))
        .toList();

    for (String path in sampleMediaPaths) {
      final fileName = path.split('/').last;
      final type = fileName.endsWith('.mp3') || fileName.endsWith('.wav')
          ? 'audio'
          : 'video';

      final sampleFile = MediaFile(
        name: fileName,
        path: path,
        type: type,
        duration: 180000, // قيمة افتراضية
        size: 5000000, // قيمة افتراضية
        dateAdded: DateTime.now(),
        lastPlayed: DateTime.now(),
        isMissing: !(await File(
          path,
        ).exists()), // Check existence for sample files too
      );

      _allMediaFiles.add(sampleFile);
    }

    // تحديث القوائم الأخرى
    _recentFiles = _allMediaFiles.toList();
    _favoriteFiles = _allMediaFiles.where((file) => file.isFavorite).toList();

    // Re-filter after adding sample files to populate _missingFiles correctly
    final allFilesCombined = [..._allMediaFiles, ..._missingFiles];
    _allMediaFiles = allFilesCombined.where((file) => !file.isMissing).toList();
    _missingFiles = allFilesCombined.where((file) => file.isMissing).toList();
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
    final files = await _databaseService.getMediaFilesByType(type);
    return files.where((file) => !file.isMissing).toList();
  }

  Future<void> deleteMediaFile(MediaFile file) async {
    if (file.id != null) {
      await _databaseService.deleteMediaFile(file.id!);

      // Remove from internal lists
      _allMediaFiles.removeWhere((mf) => mf.id == file.id);
      _recentFiles.removeWhere((mf) => mf.id == file.id);
      _favoriteFiles.removeWhere((mf) => mf.id == file.id);
      _missingFiles.removeWhere(
        (mf) => mf.id == file.id,
      ); // Remove from missing list too

      // Also remove from any playlists it might be in
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
      _updateStatistics();
      notifyListeners();
    }
  }

  Future<List<MediaFile>> getPlaylistMediaFiles(int playlistId) async {
    final files = await _databaseService.getPlaylistMediaFiles(playlistId);
    return files.where((file) => !file.isMissing).toList();
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

  Map<String, List<MediaFile>> getGroupedMediaFilesByDirectory() {
    final Map<String, List<MediaFile>> groupedFiles = {};
    for (var file in _allMediaFiles) {
      final directoryPath = p.dirname(file.path); // Use p.dirname
      final directoryName = p.basename(
        directoryPath,
      ); // Get just the folder name
      if (!groupedFiles.containsKey(directoryName)) {
        groupedFiles[directoryName] = [];
      }
      groupedFiles[directoryName]!.add(file);
    }
    return groupedFiles;
  }

  // Get media file by ID
  MediaFile? getMediaFileById(int id) {
    try {
      return _allMediaFiles.firstWhere((file) => file.id == id);
    } catch (e) {
      return null;
    }
  }

  // Reorder playlist items
  Future<void> reorderPlaylist(Playlist playlist, int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    
    final updatedMediaIds = List<int>.from(playlist.mediaFileIds);
    final item = updatedMediaIds.removeAt(oldIndex);
    updatedMediaIds.insert(newIndex, item);
    
    final updatedPlaylist = playlist.copyWith(
      mediaFileIds: updatedMediaIds,
      lastModified: DateTime.now(),
    );
    
    await _databaseService.updatePlaylist(updatedPlaylist);
    await _loadPlaylists();
    notifyListeners();
  }

  // Group media files by artist
  Map<String, List<MediaFile>> getGroupedMediaFilesByArtist() {
    final Map<String, List<MediaFile>> groupedFiles = {};
    for (var file in _allMediaFiles) {
      final artist = file.artist ?? 'Unknown Artist';
      if (!groupedFiles.containsKey(artist)) {
        groupedFiles[artist] = [];
      }
      groupedFiles[artist]!.add(file);
    }
    return groupedFiles;
  }

  // Group media files by album
  Map<String, List<MediaFile>> getGroupedMediaFilesByAlbum() {
    final Map<String, List<MediaFile>> groupedFiles = {};
    for (var file in _allMediaFiles) {
      final album = file.album ?? 'Unknown Album';
      if (!groupedFiles.containsKey(album)) {
        groupedFiles[album] = [];
      }
      groupedFiles[album]!.add(file);
    }
    return groupedFiles;
  }
}

class ScanResult {
  final int filesAdded;
  final int totalFilesFound;
  final List<MediaFile> addedFiles;
  final String? error;

  ScanResult({
    required this.totalFilesFound,
    required this.filesAdded,
    required this.addedFiles,
    this.error,
  });

  bool get hasError => error != null;
  bool get hasNewFiles => filesAdded > 0;
}
