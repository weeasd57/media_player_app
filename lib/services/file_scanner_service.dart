import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';
import 'dart:io';
import 'package:flutter/foundation.dart'; // Import foundation for debugPrint
import 'package:just_audio/just_audio.dart'; // Added for audio duration
import 'package:video_player/video_player.dart'; // Added for video duration
import '../models/media_file.dart';
import 'database_service.dart';

class FileScannerService {
  static final FileScannerService _instance = FileScannerService._internal();
  factory FileScannerService() => _instance;
  FileScannerService._internal();

  final DatabaseService _databaseService = DatabaseService();

  // Supported audio formats
  static const List<String> audioExtensions = [
    '.mp3',
    '.wav',
    '.flac',
    '.aac',
    '.ogg',
    '.m4a',
    '.wma',
  ];

  // Supported video formats
  static const List<String> videoExtensions = [
    '.mp4',
    '.avi',
    '.mkv',
    '.mov',
    '.wmv',
    '.flv',
    '.webm',
    '.m4v',
  ];

  // Get all supported extensions
  static List<String> get allSupportedExtensions => [
    ...audioExtensions,
    ...videoExtensions,
  ];

  // Check if file is supported media file
  bool isSupportedMediaFile(String filePath) {
    final extension = getFileExtension(filePath).toLowerCase();
    return allSupportedExtensions.contains(extension);
  }

  // Get file extension
  String getFileExtension(String filePath) {
    return '.${filePath.split('.').last.toLowerCase()}';
  }

  // Determine media type from file extension
  String getMediaType(String filePath) {
    final extension = getFileExtension(filePath);
    if (audioExtensions.contains(extension)) {
      return 'audio';
    } else if (videoExtensions.contains(extension)) {
      return 'video';
    }
    return 'unknown';
  }

  // Get common media directories
  Future<List<Directory>> getCommonMediaDirectories() async {
    List<Directory> directories = [];

    try {
      // External storage directories
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        directories.add(externalDir);

        // Common media folders
        final musicDir = Directory('${externalDir.parent.path}/Music');
        final videosDir = Directory('${externalDir.parent.path}/Movies');
        final downloadsDir = Directory('${externalDir.parent.path}/Download');
        final dcimDir = Directory('${externalDir.parent.path}/DCIM');

        if (await musicDir.exists()) directories.add(musicDir);
        if (await videosDir.exists()) directories.add(videosDir);
        if (await downloadsDir.exists()) directories.add(downloadsDir);
        if (await dcimDir.exists()) directories.add(dcimDir);
      }

      // Application documents directory
      final documentsDir = await getApplicationDocumentsDirectory();
      directories.add(documentsDir);
    } catch (e) {
      debugPrint('Error getting media directories: $e');
    }

    return directories;
  }

  // Scan a specific directory for media files
  Future<List<FileSystemEntity>> scanDirectory(Directory directory) async {
    List<FileSystemEntity> mediaFiles = [];

    try {
      await for (final entity in directory.list(recursive: true)) {
        if (entity is File && isSupportedMediaFile(entity.path)) {
          mediaFiles.add(entity);
        }
      }
    } catch (e) {
      debugPrint('Error scanning directory ${directory.path}: $e');
    }

    return mediaFiles;
  }

  // Scan all common directories for media files
  Future<List<FileSystemEntity>> scanAllDirectories({
    Function(String)? onDirectoryChanged,
    Function(int, int)? onProgress,
  }) async {
    List<FileSystemEntity> allMediaFiles = [];
    final directories = await getCommonMediaDirectories();

    for (int i = 0; i < directories.length; i++) {
      final directory = directories[i];
      onDirectoryChanged?.call(directory.path);

      final files = await scanDirectory(directory);
      allMediaFiles.addAll(files);

      onProgress?.call(i + 1, directories.length);
    }

    return allMediaFiles;
  }

  // Create MediaFile object from File
  Future<MediaFile?> createMediaFileFromFile(File file) async {
    try {
      final stat = await file.stat();
      final fileName = file.path.split('/').last;
      final mediaType = getMediaType(file.path);

      // Check if file already exists in database
      final existingFile = await _databaseService.getMediaFileByPath(file.path);
      if (existingFile != null) {
        return existingFile;
      }

      final duration = await _getMediaDuration(file.path); // Get duration

      return MediaFile(
        id: null,
        name: fileName,
        path: file.path,
        type: mediaType,
        duration:
            duration?.inMilliseconds ??
            0, // Use duration from _getMediaDuration
        size: stat.size,
        dateAdded: DateTime.now(),
        lastPlayed: DateTime.now(),
        playCount: 0,
        isFavorite: false,
      );
    } catch (e) {
      debugPrint('Error creating MediaFile from ${file.path}: $e');
      return null;
    }
  }

  // Add media files to database
  Future<List<MediaFile>> addMediaFilesToDatabase(
    List<FileSystemEntity> files, {
    Function(int, int)? onProgress,
  }) async {
    List<MediaFile> addedFiles = [];

    for (int i = 0; i < files.length; i++) {
      if (files[i] is File) {
        final mediaFile = await createMediaFileFromFile(files[i] as File);
        if (mediaFile != null) {
          try {
            final id = await _databaseService.insertMediaFile(mediaFile);
            addedFiles.add(mediaFile.copyWith(id: id));
          } catch (e) {
            // File might already exist, skip it
            debugPrint('Skipping duplicate file: ${mediaFile.path}');
          }
        }
      }
      onProgress?.call(i + 1, files.length);
    }

    return addedFiles;
  }

  // Full scan and import process
  Future<ScanResult> performFullScan({
    Function(String)? onDirectoryChanged,
    Function(int, int)? onScanProgress,
    Function(int, int)? onImportProgress,
  }) async {
    try {
      // Scan for files
      final files = await scanAllDirectories(
        onDirectoryChanged: onDirectoryChanged,
        onProgress: onScanProgress,
      );

      // Add files to database
      final addedFiles = await addMediaFilesToDatabase(
        files,
        onProgress: onImportProgress,
      );

      return ScanResult(
        totalFilesFound: files.length,
        filesAdded: addedFiles.length,
        addedFiles: addedFiles,
      );
    } catch (e) {
      debugPrint('Error during full scan: $e');
      return ScanResult(
        totalFilesFound: 0,
        filesAdded: 0,
        addedFiles: [],
        error: e.toString(),
      );
    }
  }

  // Scan specific directory and import
  Future<ScanResult> scanAndImportDirectory(
    String directoryPath, {
    Function(int, int)? onProgress,
  }) async {
    try {
      final directory = Directory(directoryPath);
      if (!await directory.exists()) {
        throw Exception('Directory does not exist: $directoryPath');
      }

      final files = await scanDirectory(directory);
      final addedFiles = await addMediaFilesToDatabase(
        files,
        onProgress: onProgress,
      );

      return ScanResult(
        totalFilesFound: files.length,
        filesAdded: addedFiles.length,
        addedFiles: addedFiles,
      );
    } catch (e) {
      debugPrint('Error scanning directory $directoryPath: $e');
      return ScanResult(
        totalFilesFound: 0,
        filesAdded: 0,
        addedFiles: [],
        error: e.toString(),
      );
    }
  }

  // Remove files that no longer exist
  Future<int> cleanupMissingFiles() async {
    final allFiles = await _databaseService.getAllMediaFiles();
    int removedCount = 0;

    for (final mediaFile in allFiles) {
      final file = File(mediaFile.path);
      if (!await file.exists()) {
        await _databaseService.deleteMediaFile(mediaFile.id!);
        removedCount++;
      }
    }

    return removedCount;
  }

  // Helper method to get media duration
  Future<Duration?> _getMediaDuration(String filePath) async {
    final mediaType = getMediaType(filePath);
    if (mediaType == 'audio') {
      try {
        final audioPlayer = AudioPlayer();
        final duration = await audioPlayer.setFilePath(filePath);
        await audioPlayer.dispose();
        return duration;
      } catch (e) {
        debugPrint('Error getting audio duration for $filePath: $e');
        return null;
      }
    } else if (mediaType == 'video') {
      try {
        final videoController = VideoPlayerController.file(File(filePath));
        await videoController.initialize();
        final duration = videoController.value.duration;
        await videoController.dispose();
        return duration;
      } catch (e) {
        debugPrint('Error getting video duration for $filePath: $e');
        return null;
      }
    }
    return null;
  }

  // Old scanDevice method (re-added)
  Future<List<MediaFile>> scanDevice(Function(String) onProgress) async {
    List<MediaFile> foundFiles = [];
    try {
      onProgress('Scanning directories...');
      final directories = await getCommonMediaDirectories();
      debugPrint('Directories to scan: $directories');

      for (Directory directory in directories) {
        if (await directory.exists()) {
          await for (var entity in directory.list(recursive: true)) {
            if (entity is File) {
              final file = entity;
              final mimeType = lookupMimeType(file.path);
              if (mimeType != null &&
                  (mimeType.startsWith('audio/') ||
                      mimeType.startsWith('video/'))) {
                final duration = await _getMediaDuration(file.path);
                if (duration != null) {
                  final mediaFile = MediaFile(
                    id: null,
                    name: file.path.split('/').last,
                    path: file.path,
                    type: mimeType.split('/').first,
                    duration: duration.inSeconds,
                    size: (await file.stat()).size,
                    dateAdded: (await file.stat())
                        .changed, // or .modified or .accessed
                    lastPlayed: DateTime.now(), // default to now or null
                    playCount: 0,
                    isFavorite: false,
                  );
                  foundFiles.add(mediaFile);
                  debugPrint('Found media file: ${file.path}');
                }
              }
            }
          }
        }
      }
      onProgress('Scan complete. Found ${foundFiles.length} files.');
    } catch (e) {
      debugPrint('Error during file scan: $e');
      onProgress('Scan failed: $e');
    }
    return foundFiles;
  }

  // Old getAllFilePaths method (re-added)
  Future<List<String>> getAllFilePaths() async {
    List<String> filePaths = [];
    try {
      final directories = await getCommonMediaDirectories();
      for (Directory directory in directories) {
        if (await directory.exists()) {
          await for (var entity in directory.list(recursive: true)) {
            if (entity is File) {
              filePaths.add(entity.path);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error getting all file paths: $e');
    }
    return filePaths;
  }
}

class ScanResult {
  final int totalFilesFound;
  final int filesAdded;
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
