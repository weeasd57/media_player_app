import '../../core/enums/media_enums.dart';

class MediaItem {
  final int? id; // إضافة ID
  final String path;
  final String name;
  final MediaType type;
  final DateTime dateAdded;
  final int? duration; // بالثواني
  final int? fileSize; // بالبايت
  final bool isFavorite; // إضافة isFavorite

  MediaItem({
    this.id,
    required this.path,
    required this.name,
    required this.type,
    required this.dateAdded,
    this.duration,
    this.fileSize,
    this.isFavorite = false,
  });

  String get displayName {
    // إزالة امتداد الملف من الاسم
    final lastDotIndex = name.lastIndexOf('.');
    if (lastDotIndex != -1) {
      return name.substring(0, lastDotIndex);
    }
    return name;
  }

  String get fileExtension {
    final lastDotIndex = name.lastIndexOf('.');
    if (lastDotIndex != -1) {
      return name.substring(lastDotIndex + 1).toUpperCase();
    }
    return '';
  }

  String get formattedFileSize {
    if (fileSize == null) return 'غير معروف';
    
    if (fileSize! < 1024) {
      return '${fileSize!} B';
    } else if (fileSize! < 1024 * 1024) {
      return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    } else if (fileSize! < 1024 * 1024 * 1024) {
      return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(fileSize! / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  String get formattedDuration {
    if (duration == null) return 'غير معروف';
    
    final hours = duration! ~/ 3600;
    final minutes = (duration! % 3600) ~/ 60;
    final seconds = duration! % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
