import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/enums/media_enums.dart';
import '../entities/media_entity.dart';

/// واجهة مستودع الوسائط في طبقة المجال
abstract class MediaRepository {
  /// الحصول على جميع ملفات الوسائط
  Future<Either<Failure, List<MediaEntity>>> getAllMediaFiles();

  /// الحصول على ملفات الوسائط حسب النوع
  Future<Either<Failure, List<MediaEntity>>> getMediaFilesByType(MediaType type);

  /// الحصول على الملفات المفضلة
  Future<Either<Failure, List<MediaEntity>>> getFavoriteMediaFiles();

  /// الحصول على الملفات المشغلة مؤخراً
  Future<Either<Failure, List<MediaEntity>>> getRecentlyPlayedFiles();

  /// الحصول على ملف وسائط بالمعرف
  Future<Either<Failure, MediaEntity?>> getMediaFileById(int id);

  /// الحصول على ملف وسائط بالمسار
  Future<Either<Failure, MediaEntity?>> getMediaFileByPath(String path);

  /// إضافة ملف وسائط جديد
  Future<Either<Failure, int>> insertMediaFile(MediaEntity mediaFile);

  /// تحديث ملف وسائط
  Future<Either<Failure, void>> updateMediaFile(MediaEntity mediaFile);

  /// حذف ملف وسائط
  Future<Either<Failure, void>> deleteMediaFile(int id);

  /// تبديل حالة المفضلة
  Future<Either<Failure, void>> toggleFavorite(int id);

  /// تحديث إحصائية التشغيل
  Future<Either<Failure, void>> updatePlayCount(int id);

  /// مسح ملفات الوسائط من النظام
  Future<Either<Failure, Map<String, dynamic>>> scanForMediaFiles({
    Function(String)? onDirectoryChanged,
  });

  /// تنظيف الملفات المفقودة
  Future<Either<Failure, int>> cleanupMissingFiles();

  /// البحث في ملفات الوسائط
  Future<Either<Failure, List<MediaEntity>>> searchMediaFiles(String query);

  /// فرز ملفات الوسائط
  Future<Either<Failure, List<MediaEntity>>> sortMediaFiles(
    List<MediaEntity> mediaFiles,
    SortMethod sortMethod,
    SortOrder sortOrder,
  );

  /// الحصول على إحصائيات المكتبة
  Future<Either<Failure, Map<String, int>>> getLibraryStatistics();
}
