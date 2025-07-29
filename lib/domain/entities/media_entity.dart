import 'package:equatable/equatable.dart';
import '../../core/enums/media_enums.dart';

/// كيان الوسائط في طبقة المجال
class MediaEntity extends Equatable {
  final int? id;
  final String name;
  final String path;
  final MediaType type;
  final Duration duration;
  final int size;
  final DateTime dateAdded;
  final DateTime lastPlayed;
  final int playCount;
  final bool isFavorite;

  const MediaEntity({
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

  /// نسخ الكيان مع تغيير بعض الخصائص
  MediaEntity copyWith({
    int? id,
    String? name,
    String? path,
    MediaType? type,
    Duration? duration,
    int? size,
    DateTime? dateAdded,
    DateTime? lastPlayed,
    int? playCount,
    bool? isFavorite,
  }) {
    return MediaEntity(
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

  /// تحديث إحصائية التشغيل
  MediaEntity markAsPlayed() {
    return copyWith(
      lastPlayed: DateTime.now(),
      playCount: playCount + 1,
    );
  }

  /// تبديل حالة المفضلة
  MediaEntity toggleFavorite() {
    return copyWith(isFavorite: !isFavorite);
  }

  /// تنسيق حجم الملف
  String get formattedSize {
    const units = ['B', 'KB', 'MB', 'GB'];
    double fileSize = size.toDouble();
    int unitIndex = 0;

    while (fileSize >= 1024 && unitIndex < units.length - 1) {
      fileSize /= 1024;
      unitIndex++;
    }

    return '${fileSize.toStringAsFixed(1)} ${units[unitIndex]}';
  }

  /// تنسيق مدة الملف
  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// امتداد الملف
  String get fileExtension {
    return path.split('.').last.toLowerCase();
  }

  /// اسم الملف بدون امتداد
  String get nameWithoutExtension {
    return name.replaceAll(RegExp(r'\.[^.]*$'), '');
  }

  @override
  List<Object?> get props => [
        id,
        name,
        path,
        type,
        duration,
        size,
        dateAdded,
        lastPlayed,
        playCount,
        isFavorite,
      ];

  @override
  String toString() {
    return 'MediaEntity('
        'id: $id, '
        'name: $name, '
        'type: $type, '
        'duration: $formattedDuration, '
        'size: $formattedSize'
        ')';
  }
}
