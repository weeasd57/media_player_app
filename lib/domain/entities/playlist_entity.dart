import 'package:equatable/equatable.dart';
import 'media_entity.dart';

/// كيان قائمة التشغيل في طبقة المجال
class PlaylistEntity extends Equatable {
  final int? id;
  final String name;
  final String description;
  final DateTime dateCreated;
  final DateTime lastModified;
  final List<int> mediaFileIds;
  final List<MediaEntity>? mediaFiles; // للاستخدام في العرض

  const PlaylistEntity({
    this.id,
    required this.name,
    this.description = '',
    required this.dateCreated,
    required this.lastModified,
    required this.mediaFileIds,
    this.mediaFiles,
  });

  /// نسخ الكيان مع تغيير بعض الخصائص
  PlaylistEntity copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? dateCreated,
    DateTime? lastModified,
    List<int>? mediaFileIds,
    List<MediaEntity>? mediaFiles,
  }) {
    return PlaylistEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dateCreated: dateCreated ?? this.dateCreated,
      lastModified: lastModified ?? this.lastModified,
      mediaFileIds: mediaFileIds ?? this.mediaFileIds,
      mediaFiles: mediaFiles ?? this.mediaFiles,
    );
  }

  /// إضافة ملف وسائط لقائمة التشغيل
  PlaylistEntity addMediaFile(int mediaFileId) {
    if (mediaFileIds.contains(mediaFileId)) {
      return this;
    }

    return copyWith(
      mediaFileIds: [...mediaFileIds, mediaFileId],
      lastModified: DateTime.now(),
    );
  }

  /// إزالة ملف وسائط من قائمة التشغيل
  PlaylistEntity removeMediaFile(int mediaFileId) {
    if (!mediaFileIds.contains(mediaFileId)) {
      return this;
    }

    final updatedIds = List<int>.from(mediaFileIds)..remove(mediaFileId);
    return copyWith(mediaFileIds: updatedIds, lastModified: DateTime.now());
  }

  /// ترتيب ملفات الوسائط في قائمة التشغيل
  PlaylistEntity reorderMediaFiles(int oldIndex, int newIndex) {
    final updatedIds = List<int>.from(mediaFileIds);
    final item = updatedIds.removeAt(oldIndex);
    updatedIds.insert(newIndex, item);

    return copyWith(mediaFileIds: updatedIds, lastModified: DateTime.now());
  }

  /// تحديث قائمة التشغيل مع ملفات الوسائط
  PlaylistEntity withMediaFiles(List<MediaEntity> files) {
    return copyWith(mediaFiles: files);
  }

  /// عدد الملفات في قائمة التشغيل
  int get mediaCount => mediaFileIds.length;

  /// المدة الإجمالية لقائمة التشغيل
  Duration get totalDuration {
    if (mediaFiles == null) return Duration.zero;

    return mediaFiles!.fold<Duration>(
      Duration.zero,
      (total, media) => total + media.duration,
    );
  }

  /// تنسيق المدة الإجمالية
  String get formattedTotalDuration {
    final hours = totalDuration.inHours;
    final minutes = totalDuration.inMinutes.remainder(60);
    final seconds = totalDuration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hoursس $minutesد';
    } else if (minutes > 0) {
      return '$minutesد $secondsث';
    } else {
      return '$secondsث';
    }
  }

  /// هل قائمة التشغيل فارغة
  bool get isEmpty => mediaFileIds.isEmpty;

  /// هل قائمة التشغيل غير فارغة
  bool get isNotEmpty => mediaFileIds.isNotEmpty;

  /// التحقق من وجود ملف وسائط في القائمة
  bool containsMediaFile(int mediaFileId) {
    return mediaFileIds.contains(mediaFileId);
  }

  /// الحصول على فهرس ملف وسائط في القائمة
  int getMediaFileIndex(int mediaFileId) {
    return mediaFileIds.indexOf(mediaFileId);
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    dateCreated,
    lastModified,
    mediaFileIds,
    mediaFiles,
  ];

  @override
  String toString() {
    return 'PlaylistEntity('
        'id: $id, '
        'name: $name, '
        'mediaCount: $mediaCount, '
        'totalDuration: $formattedTotalDuration'
        ')';
  }
}
