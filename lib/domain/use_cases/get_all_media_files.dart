import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/media_entity.dart';
import '../repositories/media_repository.dart';

/// حالة استخدام للحصول على جميع ملفات الوسائط
class GetAllMediaFiles {
  final MediaRepository repository;

  GetAllMediaFiles(this.repository);

  Future<Either<Failure, List<MediaEntity>>> call() async {
    return await repository.getAllMediaFiles();
  }
}
