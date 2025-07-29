class MediaFile {
  final int? id;
  final String name;
  final String path;
  final String type; // 'audio' or 'video'
  final int duration; // in milliseconds
  final int size; // in bytes
  final DateTime dateAdded;
  final DateTime lastPlayed;
  final int playCount;
  final bool isFavorite;

  MediaFile({
    this.id,
    required this.name,
    required this.path,
    required this.type,
    required this.duration,
    required this.size,
    required this.dateAdded,
    required this.lastPlayed,
    this.playCount = 0,
    this.isFavorite = false,
  });

  // Convert MediaFile to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'type': type,
      'duration': duration,
      'size': size,
      'dateAdded': dateAdded.millisecondsSinceEpoch,
      'lastPlayed': lastPlayed.millisecondsSinceEpoch,
      'playCount': playCount,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  // Create MediaFile from Map (database result)
  factory MediaFile.fromMap(Map<String, dynamic> map) {
    return MediaFile(
      id: map['id'],
      name: map['name'],
      path: map['path'],
      type: map['type'],
      duration: map['duration'],
      size: map['size'],
      dateAdded: DateTime.fromMillisecondsSinceEpoch(map['dateAdded']),
      lastPlayed: DateTime.fromMillisecondsSinceEpoch(map['lastPlayed']),
      playCount: map['playCount'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  // Create a copy with updated values
  MediaFile copyWith({
    int? id,
    String? name,
    String? path,
    String? type,
    int? duration,
    int? size,
    DateTime? dateAdded,
    DateTime? lastPlayed,
    int? playCount,
    bool? isFavorite,
  }) {
    return MediaFile(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      size: size ?? this.size,
      dateAdded: dateAdded ?? this.dateAdded,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      playCount: playCount ?? this.playCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // Format duration for display
  String get formattedDuration {
    final minutes = duration ~/ 60000;
    final seconds = (duration % 60000) ~/ 1000;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Format file size for display
  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  String toString() {
    return 'MediaFile{id: $id, name: $name, type: $type, duration: $formattedDuration}';
  }
}