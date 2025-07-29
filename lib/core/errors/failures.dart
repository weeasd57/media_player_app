import 'package:equatable/equatable.dart';

/// الفئة الأساسية للأخطاء
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// خطأ في قاعدة البيانات
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.code,
  });
}

/// خطأ في الملف
class FileFailure extends Failure {
  const FileFailure({
    required super.message,
    super.code,
  });
}

/// خطأ في الصلاحيات
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
  });
}

/// خطأ في المسح
class ScanFailure extends Failure {
  const ScanFailure({
    required super.message,
    super.code,
  });
}

/// خطأ في التشغيل
class PlaybackFailure extends Failure {
  const PlaybackFailure({
    required super.message,
    super.code,
  });
}

/// خطأ في الشبكة
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
  });
}

/// خطأ في التخزين المحلي
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });
}

/// خطأ عام غير متوقع
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required super.message,
    super.code,
  });
}

/// أخطاء التحقق من صحة البيانات
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}
