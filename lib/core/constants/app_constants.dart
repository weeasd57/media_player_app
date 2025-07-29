/// ثوابت التطبيق الأساسية
class AppConstants {
  // معلومات التطبيق
  static const String appName = 'Media Player';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'مشغل الوسائط المتقدم';

  // إعدادات قاعدة البيانات
  static const String databaseName = 'media_player.db';
  static const int databaseVersion = 1;

  // أنواع الملفات المدعومة
  static const List<String> supportedAudioFormats = [
    '.mp3',
    '.wav',
    '.flac',
    '.aac',
    '.ogg',
    '.m4a',
    '.wma'
  ];

  static const List<String> supportedVideoFormats = [
    '.mp4',
    '.avi',
    '.mkv',
    '.mov',
    '.wmv',
    '.flf',
    '.3gp',
    '.webm'
  ];

  // إعدادات المسح
  static const int maxScanDepth = 10;
  static const int batchSize = 100;
  static const Duration scanTimeout = Duration(minutes: 30);

  // إعدادات التشغيل
  static const int defaultVolume = 80;
  static const Duration seekStepDuration = Duration(seconds: 10);
  static const Duration bufferDuration = Duration(seconds: 30);

  // إعدادات الواجهة
  static const double defaultBorderRadius = 12.0;
  static const double largeBorderRadius = 20.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // أحجام الأيقونات
  static const double smallIconSize = 16.0;
  static const double defaultIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double hugeIconSize = 64.0;

  // مفاتيح التخزين المحلي
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  static const String volumeKey = 'player_volume';
  static const String repeatModeKey = 'repeat_mode';
  static const String shuffleModeKey = 'shuffle_mode';
  static const String lastPlayedKey = 'last_played_file';

  // رسائل الخطأ
  static const String genericError = 'حدث خطأ غير متوقع';
  static const String networkError = 'خطأ في الاتصال بالشبكة';
  static const String permissionError = 'ليس لديك الصلاحيات المطلوبة';
  static const String fileNotFoundError = 'الملف غير موجود';
}
