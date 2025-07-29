/// تعدادات نوع الوسائط
enum MediaType {
  audio,
  video,
  unknown;

  String get displayName {
    switch (this) {
      case MediaType.audio:
        return 'صوتي';
      case MediaType.video:
        return 'مرئي';
      case MediaType.unknown:
        return 'غير معروف';
    }
  }

  String get value {
    switch (this) {
      case MediaType.audio:
        return 'audio';
      case MediaType.video:
        return 'video';
      case MediaType.unknown:
        return 'unknown';
    }
  }

  static MediaType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'audio':
        return MediaType.audio;
      case 'video':
        return MediaType.video;
      default:
        return MediaType.unknown;
    }
  }
}

/// تعدادات حالة التشغيل
enum PlaybackState {
  playing,
  paused,
  stopped,
  loading,
  error;

  String get displayName {
    switch (this) {
      case PlaybackState.playing:
        return 'يتم التشغيل';
      case PlaybackState.paused:
        return 'متوقف مؤقتاً';
      case PlaybackState.stopped:
        return 'متوقف';
      case PlaybackState.loading:
        return 'يتم التحميل';
      case PlaybackState.error:
        return 'خطأ';
    }
  }
}

/// تعدادات وضع التكرار
enum RepeatMode {
  none,
  one,
  all;

  String get displayName {
    switch (this) {
      case RepeatMode.none:
        return 'بدون تكرار';
      case RepeatMode.one:
        return 'تكرار واحد';
      case RepeatMode.all:
        return 'تكرار الكل';
    }
  }

  RepeatMode get next {
    switch (this) {
      case RepeatMode.none:
        return RepeatMode.one;
      case RepeatMode.one:
        return RepeatMode.all;
      case RepeatMode.all:
        return RepeatMode.none;
    }
  }
}

/// تعدادات طريقة الفرز
enum SortMethod {
  name,
  dateAdded,
  dateModified,
  size,
  duration,
  playCount;

  String get displayName {
    switch (this) {
      case SortMethod.name:
        return 'الاسم';
      case SortMethod.dateAdded:
        return 'تاريخ الإضافة';
      case SortMethod.dateModified:
        return 'تاريخ التعديل';
      case SortMethod.size:
        return 'الحجم';
      case SortMethod.duration:
        return 'المدة';
      case SortMethod.playCount:
        return 'عدد التشغيل';
    }
  }
}

/// تعدادات اتجاه الفرز
enum SortOrder {
  ascending,
  descending;

  String get displayName {
    switch (this) {
      case SortOrder.ascending:
        return 'تصاعدي';
      case SortOrder.descending:
        return 'تنازلي';
    }
  }
}

/// تعدادات حالة المسح
enum ScanStatus {
  idle,
  scanning,
  completed,
  error;

  String get displayName {
    switch (this) {
      case ScanStatus.idle:
        return 'في الانتظار';
      case ScanStatus.scanning:
        return 'يتم المسح';
      case ScanStatus.completed:
        return 'اكتمل';
      case ScanStatus.error:
        return 'خطأ';
    }
  }
}

/// تعدادات نوع المظهر
enum ThemeType {
  light,
  dark,
  system;

  String get displayName {
    switch (this) {
      case ThemeType.light:
        return 'فاتح';
      case ThemeType.dark:
        return 'داكن';
      case ThemeType.system:
        return 'النظام';
    }
  }
}
