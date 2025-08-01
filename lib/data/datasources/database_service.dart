import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/media_file.dart';
import '../models/playlist.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'media_player.db');

    return await openDatabase(
      path,
      version: 2, // Increment version for schema change
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // New: Add onUpgrade callback
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create media_files table
    await db.execute('''
      CREATE TABLE media_files (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        path TEXT NOT NULL UNIQUE,
        type TEXT NOT NULL,
        duration INTEGER NOT NULL,
        size INTEGER NOT NULL,
        dateAdded INTEGER NOT NULL,
        lastPlayed INTEGER NOT NULL,
        playCount INTEGER DEFAULT 0,
        isFavorite INTEGER DEFAULT 0,
        isMissing INTEGER DEFAULT 0 -- New: isMissing column
      )
    ''');

    // Create playlists table
    await db.execute('''
      CREATE TABLE playlists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        dateCreated INTEGER NOT NULL,
        lastModified INTEGER NOT NULL,
        mediaFileIds TEXT
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_media_type ON media_files(type)');
    await db.execute(
      'CREATE INDEX idx_media_favorite ON media_files(isFavorite)',
    );
    await db.execute(
      'CREATE INDEX idx_media_last_played ON media_files(lastPlayed)',
    );
  }

  // New: onUpgrade callback for database schema changes
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add the new column 'isMissing' to 'media_files' table
      await db.execute(
        'ALTER TABLE media_files ADD COLUMN isMissing INTEGER DEFAULT 0',
      );
    }
    // Add other migration steps for future versions here
  }

  // Media Files Operations
  Future<int> insertMediaFile(MediaFile mediaFile) async {
    final db = await database;
    return await db.insert('media_files', mediaFile.toMap());
  }

  Future<List<MediaFile>> getAllMediaFiles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('media_files');
    return List.generate(maps.length, (i) => MediaFile.fromMap(maps[i]));
  }

  Future<List<MediaFile>> getMediaFilesByType(String type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'media_files',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => MediaFile.fromMap(maps[i]));
  }

  Future<List<MediaFile>> getFavoriteMediaFiles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'media_files',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'lastPlayed DESC',
    );
    return List.generate(maps.length, (i) => MediaFile.fromMap(maps[i]));
  }

  Future<List<MediaFile>> getRecentlyPlayedFiles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'media_files',
      where: 'playCount > ?',
      whereArgs: [0],
      orderBy: 'lastPlayed DESC',
      limit: 20,
    );
    return List.generate(maps.length, (i) => MediaFile.fromMap(maps[i]));
  }

  Future<MediaFile?> getMediaFileById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'media_files',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return MediaFile.fromMap(maps.first);
    }
    return null;
  }

  Future<MediaFile?> getMediaFileByPath(String path) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'media_files',
      where: 'path = ?',
      whereArgs: [path],
    );
    if (maps.isNotEmpty) {
      return MediaFile.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateMediaFile(MediaFile mediaFile) async {
    final db = await database;
    return await db.update(
      'media_files',
      mediaFile.toMap(),
      where: 'id = ?',
      whereArgs: [mediaFile.id],
    );
  }

  Future<int> deleteMediaFile(int id) async {
    final db = await database;
    return await db.delete('media_files', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updatePlayCount(int id) async {
    final db = await database;
    await db.rawUpdate(
      '''
      UPDATE media_files 
      SET playCount = playCount + 1, lastPlayed = ? 
      WHERE id = ?
    ''',
      [DateTime.now().millisecondsSinceEpoch, id],
    );
  }

  Future<void> toggleFavorite(int id) async {
    final db = await database;
    await db.rawUpdate(
      '''
      UPDATE media_files 
      SET isFavorite = CASE WHEN isFavorite = 1 THEN 0 ELSE 1 END 
      WHERE id = ?
    ''',
      [id],
    );
  }

  // Playlist Operations
  Future<int> insertPlaylist(Playlist playlist) async {
    final db = await database;
    return await db.insert('playlists', playlist.toMap());
  }

  Future<List<Playlist>> getAllPlaylists() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'playlists',
      orderBy: 'lastModified DESC',
    );
    return List.generate(maps.length, (i) => Playlist.fromMap(maps[i]));
  }

  Future<Playlist?> getPlaylistById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'playlists',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Playlist.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updatePlaylist(Playlist playlist) async {
    final db = await database;
    return await db.update(
      'playlists',
      playlist.toMap(),
      where: 'id = ?',
      whereArgs: [playlist.id],
    );
  }

  Future<int> deletePlaylist(int id) async {
    final db = await database;
    return await db.delete('playlists', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<MediaFile>> getPlaylistMediaFiles(int playlistId) async {
    final playlist = await getPlaylistById(playlistId);
    if (playlist == null || playlist.mediaFileIds.isEmpty) {
      return [];
    }

    final db = await database;
    final placeholders = playlist.mediaFileIds.map((_) => '?').join(',');
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM media_files WHERE id IN ($placeholders)',
      playlist.mediaFileIds,
    );

    return List.generate(maps.length, (i) => MediaFile.fromMap(maps[i]));
  }

  // Search Operations
  Future<List<MediaFile>> searchMediaFiles(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'media_files',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => MediaFile.fromMap(maps[i]));
  }

  Future<List<Playlist>> searchPlaylists(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'playlists',
      where: 'name LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => Playlist.fromMap(maps[i]));
  }

  // Statistics
  Future<Map<String, int>> getMediaStatistics() async {
    final db = await database;

    final audioCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM media_files WHERE type = ?', [
            'audio',
          ]),
        ) ??
        0;

    final videoCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM media_files WHERE type = ?', [
            'video',
          ]),
        ) ??
        0;

    final favoriteCount =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM media_files WHERE isFavorite = ?',
            [1],
          ),
        ) ??
        0;

    final playlistCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM playlists'),
        ) ??
        0;

    return {
      'audio': audioCount,
      'video': videoCount,
      'favorites': favoriteCount,
      'playlists': playlistCount,
    };
  }

  // Clear all data
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('media_files');
    await db.delete('playlists');
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
