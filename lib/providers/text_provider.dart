import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class TextProvider extends ChangeNotifier {
  String _currentLanguage = 'ar';
  // static const String _languageKey = 'language';

  String get currentLanguage => _currentLanguage;

  TextProvider() {
    // _loadLanguage();
  }

  // تحميل اللغة من التخزين المحلي
  // Future<void> _loadLanguage() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   _currentLanguage = prefs.getString(_languageKey) ?? 'ar';
  //   notifyListeners();
  // }

  // تغيير اللغة
  void changeLanguage(String languageCode) {
    if (_currentLanguage != languageCode) {
      _currentLanguage = languageCode;
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString(_languageKey, languageCode);
      notifyListeners();
    }
  }

  // الحصول على النص بناءً على اللغة الحالية
  String getText(String key) {
    return _texts[_currentLanguage]?[key] ?? _texts['ar']?[key] ?? key;
  }

  // قاموس النصوص للغات المختلفة
  static const Map<String, Map<String, String>> _texts = {
    'ar': {
      // العامة
      'app_name': 'مشغل الوسائط',
      'yes': 'نعم',
      'no': 'لا',
      'ok': 'موافق',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'add': 'إضافة',
      'search': 'بحث',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'success': 'نجح',
      'warning': 'تحذير',
      'info': 'معلومات',

      // الشاشة الرئيسية
      'media_player': 'مشغل الوسائط',
      'ultimate_media_companion': 'رفيقك الإعلامي المثالي',
      'setting_up_library': 'جاري إعداد مكتبتك...',
      'storage_permission_required': 'أذونات التخزين مطلوبة للوصول إلى ملفات الوسائط',
      'permission_error': 'خطأ في طلب الأذونات',

      // التنقل السفلي
      'home': 'الرئيسية',
      'library': 'المكتبة',
      'playlists': 'قوائم التشغيل',
      'settings': 'الإعدادات',

      // المكتبة
      'audio_files': 'الملفات الصوتية',
      'video_files': 'ملفات الفيديو',
      'all_files': 'جميع الملفات',
      'scan_files': 'فحص الملفات',
      'no_files_found': 'لم يتم العثور على ملفات',
      'scanning_files': 'جاري فحص الملفات...',
      'files_found': 'تم العثور على {count} ملف',

      // المشغل
      'now_playing': 'قيد التشغيل الآن',
      'play': 'تشغيل',
      'pause': 'إيقاف مؤقت',
      'stop': 'إيقاف',
      'next': 'التالي',
      'previous': 'السابق',
      'shuffle': 'عشوائي',
      'repeat': 'إعادة',
      'volume': 'مستوى الصوت',
      'duration': 'المدة',
      'position': 'الموضع',
      'playback': 'التشغيل',

      // قوائم التشغيل
      'create_playlist': 'إنشاء قائمة تشغيل',
      'playlist_name': 'اسم قائمة التشغيل',
      'add_to_playlist': 'إضافة إلى قائمة التشغيل',
      'remove_from_playlist': 'إزالة من قائمة التشغيل',
      'playlist_created': 'تم إنشاء قائمة التشغيل',
      'playlist_deleted': 'تم حذف قائمة التشغيل',
      'empty_playlist': 'قائمة التشغيل فارغة',
      'delete_playlist': 'حذف قائمة التشغيل',
      'delete_playlist_confirmation': 'هل أنت متأكد من حذف قائمة التشغيل؟',

      // الإعدادات
      'theme': 'المظهر',
      'dark_mode': 'الوضع المظلم',
      'light_mode': 'الوضع الفاتح',
      'language': 'اللغة',
      'arabic': 'العربية',
      'english': 'الإنجليزية',
      'about': 'حول التطبيق',
      'version': 'الإصدار',
      'developer': 'المطور',
      'privacy_policy': 'سياسة الخصوصية',
      'terms_of_service': 'شروط الخدمة',

      // رسائل الخطأ
      'file_not_found': 'الملف غير موجود',
      'playback_error': 'خطأ في التشغيل',
      'network_error': 'خطأ في الشبكة',
      'permission_denied': 'تم رفض الإذن',
      'storage_error': 'خطأ في التخزين',
      'unknown_error': 'خطأ غير معروف',

      // معلومات الملف
      'file_name': 'اسم الملف',
      'file_size': 'حجم الملف',
      'file_path': 'مسار الملف',
      'file_type': 'نوع الملف',
      'date_modified': 'تاريخ التعديل',
      'date_created': 'تاريخ الإنشاء',
      'artist': 'الفنان',
      'album': 'الألبوم',
      'genre': 'النوع',
      'year': 'السنة',

      // أزرار التحكم
      'play_all': 'تشغيل الكل',
      'shuffle_all': 'تشغيل عشوائي للكل',
      'sort_by': 'ترتيب حسب',
      'sort_by_name': 'الاسم',
      'sort_by_date': 'التاريخ',
      'sort_by_size': 'الحجم',
      'sort_by_duration': 'المدة',
      'ascending': 'تصاعدي',
      'descending': 'تنازلي',

      // حالات المشغل
      'playing': 'قيد التشغيل',
      'paused': 'متوقف مؤقتاً',
      'stopped': 'متوقف',
      'loading_media': 'جاري تحميل الوسائط...',
      'buffering': 'جاري التخزين المؤقت...',
      'ready': 'جاهز',

      // إشعارات
      'notification_title': 'مشغل الوسائط',
      'notification_subtitle': 'قيد التشغيل الآن',
      'notification_play': 'تشغيل',
      'notification_pause': 'إيقاف مؤقت',
      'notification_next': 'التالي',
      'notification_previous': 'السابق',
    },

    'en': {
      // General
      'app_name': 'Media Player',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'search': 'Search',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'warning': 'Warning',
      'info': 'Information',

      // Main Screen
      'media_player': 'Media Player',
      'ultimate_media_companion': 'Your ultimate media companion',
      'setting_up_library': 'Setting up your library...',
      'storage_permission_required': 'Storage permissions are required to access media files',
      'permission_error': 'Error requesting permissions',

      // Bottom Navigation
      'home': 'Home',
      'library': 'Library',
      'playlists': 'Playlists',
      'settings': 'Settings',

      // Library
      'audio_files': 'Audio Files',
      'video_files': 'Video Files',
      'all_files': 'All Files',
      'scan_files': 'Scan Files',
      'no_files_found': 'No files found',
      'scanning_files': 'Scanning files...',
      'files_found': '{count} files found',

      // Player
      'now_playing': 'Now Playing',
      'play': 'Play',
      'pause': 'Pause',
      'stop': 'Stop',
      'next': 'Next',
      'previous': 'Previous',
      'shuffle': 'Shuffle',
      'repeat': 'Repeat',
      'volume': 'Volume',
      'duration': 'Duration',
      'position': 'Position',
      'playback': 'Playback',

      // Playlists
      'create_playlist': 'Create Playlist',
      'playlist_name': 'Playlist Name',
      'add_to_playlist': 'Add to Playlist',
      'remove_from_playlist': 'Remove from Playlist',
      'playlist_created': 'Playlist created',
      'playlist_deleted': 'Playlist deleted',
      'empty_playlist': 'Empty playlist',
      'delete_playlist': 'Delete Playlist',
      'delete_playlist_confirmation': 'Are you sure you want to delete this playlist?',

      // Settings
      'theme': 'Theme',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'language': 'Language',
      'arabic': 'Arabic',
      'english': 'English',
      'about': 'About',
      'version': 'Version',
      'developer': 'Developer',
      'privacy_policy': 'Privacy Policy',
      'terms_of_service': 'Terms of Service',

      // Error Messages
      'file_not_found': 'File not found',
      'playback_error': 'Playback error',
      'network_error': 'Network error',
      'permission_denied': 'Permission denied',
      'storage_error': 'Storage error',
      'unknown_error': 'Unknown error',

      // File Information
      'file_name': 'File Name',
      'file_size': 'File Size',
      'file_path': 'File Path',
      'file_type': 'File Type',
      'date_modified': 'Date Modified',
      'date_created': 'Date Created',
      'artist': 'Artist',
      'album': 'Album',
      'genre': 'Genre',
      'year': 'Year',

      // Control Buttons
      'play_all': 'Play All',
      'shuffle_all': 'Shuffle All',
      'sort_by': 'Sort By',
      'sort_by_name': 'Name',
      'sort_by_date': 'Date',
      'sort_by_size': 'Size',
      'sort_by_duration': 'Duration',
      'ascending': 'Ascending',
      'descending': 'Descending',

      // Player States
      'playing': 'Playing',
      'paused': 'Paused',
      'stopped': 'Stopped',
      'loading_media': 'Loading media...',
      'buffering': 'Buffering...',
      'ready': 'Ready',

      // Notifications
      'notification_title': 'Media Player',
      'notification_subtitle': 'Now Playing',
      'notification_play': 'Play',
      'notification_pause': 'Pause',
      'notification_next': 'Next',
      'notification_previous': 'Previous',
    },
  };

  // قائمة اللغات المتاحة
  List<Map<String, String>> get availableLanguages => [
        {'code': 'ar', 'name': getText('arabic')},
        {'code': 'en', 'name': getText('english')},
      ];

  // تحديد اتجاه النص
  TextDirection get textDirection {
    return _currentLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }

  // تحديد اتجاه التطبيق
  bool get isRTL => _currentLanguage == 'ar';
}
