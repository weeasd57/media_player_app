import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/enums/media_enums.dart';
import '../entities/playlist_entity.dart';
import '../entities/media_entity.dart';

/// واجهة مستودع قوائم التشغيل في طبقة المجال
abstract class PlaylistRepository {
  /// الحصول على جميع قوائم التشغيل
  Future<Either<Failure, List<PlaylistEntity>>> getAllPlaylists();

  /// الحصول على قائمة التشغيل بالمعرف
  Future<Either<Failure, PlaylistEntity?>> getPlaylistById(int id);

  /// إضافة قائمة تشغيل جديدة
  Future<Either<Failure, int>> insertPlaylist(PlaylistEntity playlist);

  /// تحديث قائمة التشغيل
  Future<Either<Failure, void>> updatePlaylist(PlaylistEntity playlist);

  /// حذف قائمة التشغيل
  Future<Either<Failure, void>> deletePlaylist(int id);

  /// تنظيف القوائم الفارغة
  Future<Either<Failure, int>> cleanupEmptyPlaylists();

  /// فرز قوائم التشغيل
  Future<Either<Failure, List<PlaylistEntity>>> sortPlaylists(
    List<PlaylistEntity> playlists,
    SortMethod sortMethod,
    SortOrder sortOrder,
  );

  /// ربط ملفات الوسائط مع قوائم التشغيل
  Future<Either<Failure, PlaylistEntity>> linkMediaFilesWithPlaylist(
    PlaylistEntity playlist,
    List<MediaEntity> mediaFiles,
  );

  /// الحصول على ملفات الوسائط في قائمة تشغيل
  Future<Either<Failure, List<MediaEntity>>> getMediaFilesInPlaylist(
    PlaylistEntity playlist,
  );
}
