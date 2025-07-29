class Playlist {
  final int? id;
  final String name;
  final String description;
  final DateTime dateCreated;
  final DateTime lastModified;
  final List<int> mediaFileIds; // List of media file IDs

  Playlist({
    this.id,
    required this.name,
    this.description = '',
    required this.dateCreated,
    required this.lastModified,
    this.mediaFileIds = const [],
  });

  // Convert Playlist to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dateCreated': dateCreated.millisecondsSinceEpoch,
      'lastModified': lastModified.millisecondsSinceEpoch,
      'mediaFileIds': mediaFileIds.join(','), // Store as comma-separated string
    };
  }

  // Create Playlist from Map (database result)
  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
      dateCreated: DateTime.fromMillisecondsSinceEpoch(map['dateCreated']),
      lastModified: DateTime.fromMillisecondsSinceEpoch(map['lastModified']),
      mediaFileIds: map['mediaFileIds'] != null && map['mediaFileIds'].isNotEmpty
          ? map['mediaFileIds'].split(',').map<int>((id) => int.parse(id)).toList()
          : [],
    );
  }

  // Create a copy with updated values
  Playlist copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? dateCreated,
    DateTime? lastModified,
    List<int>? mediaFileIds,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dateCreated: dateCreated ?? this.dateCreated,
      lastModified: lastModified ?? this.lastModified,
      mediaFileIds: mediaFileIds ?? this.mediaFileIds,
    );
  }

  // Get the number of media files in this playlist
  int get mediaCount => mediaFileIds.length;

  @override
  String toString() {
    return 'Playlist{id: $id, name: $name, mediaCount: $mediaCount}';
  }
}