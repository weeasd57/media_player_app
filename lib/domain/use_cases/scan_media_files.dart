import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/media_repository.dart';

/// معاملات حالة استخدام مسح ملفات الوسائط
class ScanMediaFilesParams {
  final Function(String)? onDirectoryChanged;

  const ScanMediaFilesParams({
    this.onDirectoryChanged,
  });
}

/// حالة استخدام لمسح ملفات الوسائط من النظام
class ScanMediaFiles {
  final MediaRepository repository;

  ScanMediaFiles(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
    ScanMediaFilesParams params,
  ) async {
    return await repository.scanForMediaFiles(
      onDirectoryChanged: params.onDirectoryChanged,
    );
  }
}
