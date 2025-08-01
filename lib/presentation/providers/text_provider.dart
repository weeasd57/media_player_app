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

  // New method to handle parameterized strings
  String getTextWithParams(String key, Map<String, dynamic> params) {
    String text = getText(key);
    params.forEach((paramKey, value) {
      text = text.replaceAll('{${paramKey}}', value.toString());
    });
    return text;
  }

  // قاموس النصوص للغات المختلفة
  static const Map<String, Map<String, String>> _texts = {
    'ar': {
      // العامة
      'appName': 'مشغل الوسائط',
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
      'mediaPlayer': 'مشغل الوسائط',
      'ultimateMediaCompanion': 'رفيقك الإعلامي المثالي',
      'settingUpLibrary': 'جاري إعداد مكتبتك...',
      'storagePermissionRequired':
          'أذونات التخزين مطلوبة للوصول إلى ملفات الوسائط',
      'permissionError': 'خطأ في طلب الأذونات',
      'goodMorning': 'صباح الخير!',
      'goodAfternoon': 'مساء الخير!',
      'goodEvening': 'مساء الخير!',
      'yourLibrary': 'مكتبتك',
      'recentlyPlayed': 'تم تشغيلها مؤخراً',
      'yourFavorites': 'مفضلاتك',

      // التنقل السفلي
      'home': 'الرئيسية',
      'library': 'المكتبة',
      'playlists': 'قوائم التشغيل',
      'settings': 'الإعدادات',

      // المكتبة
      'audioFiles': 'الملفات الصوتية',
      'videoFiles': 'ملفات الفيديو',
      'allFiles': 'جميع الملفات',
      'scanFiles': 'فحص الملفات',
      'noFilesFound': 'لم يتم العثور على ملفات',
      'scanningFiles': 'جاري فحص الملفات...',
      'filesFound': 'تم العثور على {count} ملف',

      // المشغل
      'nowPlaying': 'قيد التشغيل الآن',
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
      'createPlaylist': 'إنشاء قائمة تشغيل',
      'playlistName': 'اسم قائمة التشغيل',
      'addToPlaylist': 'إضافة إلى قائمة تشغيل',
      'removeFromPlaylist': 'إزالة من قائمة تشغيل',
      'playlistCreated': 'تم إنشاء قائمة التشغيل',
      'playlistDeleted': 'تم حذف قائمة التشغيل',
      'emptyPlaylist': 'قائمة التشغيل فارغة',
      'deletePlaylist': 'حذف قائمة التشغيل',
      'deletePlaylistConfirmation': 'هل أنت متأكد من حذف قائمة التشغيل؟',

      // الإعدادات
      'theme': 'المظهر',
      'darkMode': 'الوضع المظلم',
      'lightMode': 'الوضع الفاتح',
      'language': 'اللغة',
      'arabic': 'العربية',
      'english': 'الإنجليزية',
      'about': 'حول التطبيق',
      'version': 'الإصدار',
      'developer': 'المطور',
      'privacyPolicy': 'سياسة الخصوصية',
      'termsOfService': 'شروط الخدمة',

      // رسائل الخطأ
      'fileNotFound': 'الملف غير موجود',
      'playbackError': 'خطأ في التشغيل',
      'networkError': 'خطأ في الشبكة',
      'permissionDenied': 'تم رفض الإذن',
      'storageError': 'خطأ في التخزين',
      'unknownError': 'خطأ غير معروف',

      // معلومات الملف
      'fileName': 'اسم الملف',
      'fileSize': 'حجم الملف',
      'filePath': 'مسار الملف',
      'fileType': 'نوع الملف',
      'dateModified': 'تاريخ التعديل',
      'dateCreated': 'تاريخ الإنشاء',
      'artist': 'الفنان',
      'album': 'الألبوم',
      'genre': 'النوع',
      'year': 'السنة',

      // أزرار التحكم
      'playAll': 'تشغيل الكل',
      'shuffleAll': 'تشغيل عشوائي للكل',
      'sortBy': 'ترتيب حسب',
      'sortByName': 'الاسم',
      'sortByDate': 'التاريخ',
      'sortBySize': 'الحجم',
      'sortByDuration': 'المدة',
      'ascending': 'تصاعدي',
      'descending': 'تنازلي',

      // حالات المشغل
      'playing': 'قيد التشغيل',
      'paused': 'متوقف مؤقتاً',
      'stopped': 'متوقف',
      'loadingMedia': 'جاري تحميل الوسائط...',
      'buffering': 'جاري التخزين المؤقت...',
      'ready': 'جاهز',

      // إشعارات
      'notificationTitle': 'مشغل الوسائط',
      'notificationSubtitle': 'قيد التشغيل الآن',
      'notificationPlay': 'تشغيل',
      'notificationPause': 'إيقاف مؤقت',
      'notificationNext': 'التالي',
      'notificationPrevious': 'السابق',

      // نصوص إضافية مفقودة
      'libraryManagement': 'إدارة المكتبة',
      'dataManagement': 'إدارة البيانات',
      'cleanLibrary': 'تنظيف المكتبة',
      'cleanLibrarySubtitle': 'حذف الملفات المفقودة من المكتبة',
      'cleanLibraryConfirmation':
          'سيتم حذف جميع الملفات المفقودة من مكتبتك. لا يمكن التراجع عن هذا الإجراء.\n\nالمتابعة؟',
      'clean': 'تنظيف',
      'continue': 'متابعة',
      'libraryCleanedSuccessfully': 'تم تنظيف المكتبة بنجاح',
      'scanComplete': 'اكتمل الفحص',
      'scanCompleteMessage': 'تم إكمال فحص الوسائط بنجاح.',
      'storageInfo': 'معلومات التخزين',
      'storageInfoSubtitle': 'عرض استخدام التخزين وإحصائيات الملفات',
      'storageInformation': 'معلومات التخزين',
      'totalFiles': 'إجمالي الملفات',
      'favorites': 'المفضلة',
      'clearAllData': 'مسح جميع البيانات',
      'clearAllDataSubtitle': 'حذف جميع قوائم التشغيل والتفضيلات',
      'clearAllDataConfirmation':
          'سيتم حذف جميع قوائم التشغيل والمفضلة وبيانات التطبيق نهائياً. لا يمكن التراجع عن هذا الإجراء.\n\nهل أنت متأكد من المتابعة؟',
      'clearAll': 'مسح الكل',
      'allDataClearedSuccessfully': 'تم مسح جميع البيانات بنجاح',
      'rateApp': 'قيم التطبيق',
      'rateAppSubtitle': 'قيمنا في متجر التطبيقات',
      'ratingFeatureComingSoon': 'ميزة التقييم قريباً!',
      'reportBug': 'الإبلاغ عن خطأ',
      'reportBugSubtitle': 'ساعدنا في تحسين التطبيق',
      'bugReportingFeatureComingSoon': 'ميزة الإبلاغ عن الأخطاء قريباً!',
      'privacyPolicySubtitle': 'اقرأ سياسة الخصوصية الخاصة بنا',
      'build': 'الإصدار',
      'appDescription':
          'مشغل وسائط حديث للملفات الصوتية ومقاطع الفيديو مع دعم قوائم التشغيل.',
      'automaticallyRepeatPlaylists': 'إعادة تشغيل قوائم التشغيل تلقائياً',
      'randomizePlaybackOrder': 'ترتيب التشغيل عشوائياً',
      'searchForNewMediaFiles': 'البحث عن ملفات وسائط جديدة على جهازك',
      'removeMissingFilesFromLibrary': 'حذف الملفات المفقودة من المكتبة',
      'viewUsageAndStatistics': 'عرض الاستخدام والإحصائيات',
      'removeAllPlaylistsAndPreferences': 'حذف جميع قوائم التشغيل والتفضيلات',
      'readOurPrivacyPolicy': 'اقرأ سياسة الخصوصية الخاصة بنا',
      'rateUsOnAppStore': 'قيمنا في متجر التطبيقات',
      'helpUsImproveApp': 'ساعدنا في تحسين التطبيق',
      'times': 'مرة',
      'playedTimes': 'تم تشغيله {count} مرة',
      'noPlaylistsAvailable': 'لا توجد قوائم تشغيل متاحة',
      'files': 'ملفات',
      'addedToPlaylist': 'تمت الإضافة إلى {name}',
      'noSearchResults': 'لا توجد نتائج بحث',
      'noFilePlaying': 'لا يوجد ملف قيد التشغيل',
      'addFilesToPlaylist': 'إضافة ملفات إلى {playlistName}',
      'filesSelected': '{count} ملفات مختارة',
      'noFilesAvailableToAdd': 'لا توجد ملفات متاحة للإضافة',
      'addWithCount': 'إضافة ({count})',
      'addedFilesToPlaylist': 'تمت إضافة {count} ملفات إلى قائمة التشغيل',
      'confirmRemoveFromFile': 'إزالة \"{fileName}\" من قائمة التشغيل؟',
      'parentDirectory': 'المجلد الأصلي',
      
      // نصوص الإعدادات الإضافية
      'auto_repeat': 'التكرار التلقائي',
      'automatically_repeat_playlists': 'تكرار قوائم التشغيل تلقائياً',
      'shuffle_mode': 'وضع الخلط',
      'randomize_playback_order': 'ترتيب التشغيل عشوائياً',
      'scan_files': 'فحص الملفات',
      'search_for_new_media_files': 'البحث عن ملفات وسائط جديدة على جهازك',
      'clean_library': 'تنظيف المكتبة',
      'remove_missing_files_from_library': 'حذف الملفات المفقودة من المكتبة',
      'storage_info': 'معلومات التخزين',
      'view_usage_and_statistics': 'عرض الاستخدام والإحصائيات',
      'data_management': 'إدارة البيانات',
      'clear_all_data': 'مسح جميع البيانات',
      'remove_all_playlists_and_preferences': 'حذف جميع قوائم التشغيل والتفضيلات',
      'app_name': 'مشغل الوسائط',
      'rate_app': 'تقييم التطبيق',
      'rate_us_on_app_store': 'قيمنا في متجر التطبيقات',
      'report_bug': 'الإبلاغ عن خطأ',
      'help_us_improve_app': 'ساعدنا في تحسين التطبيق',
      'privacy_policy': 'سياسة الخصوصية',
      'read_our_privacy_policy': 'اقرأ سياسة الخصوصية الخاصة بنا',
      
      // نصوص شاشة استكشاف الجهاز
      'exploreDevice': 'استكشاف الجهاز',
      'refresh': 'تحديث',
      'addedToFavorites': 'تمت الإضافة إلى المفضلة',
      'removedFromFavorites': 'تمت الإزالة من المفضلة',
    },

    'en': {
      // General
      'appName': 'Media Player',
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
      'mediaPlayer': 'Media Player',
      'ultimateMediaCompanion': 'Your ultimate media companion',
      'settingUpLibrary': 'Setting up your library...',
      'storagePermissionRequired':
          'Storage permissions are required to access media files',
      'permissionError': 'Error requesting permissions',
      'goodMorning': 'Good Morning!',
      'goodAfternoon': 'Good Afternoon!',
      'goodEvening': 'Good Evening!',
      'yourLibrary': 'Your Library',
      'recentlyPlayed': 'Recently Played',
      'yourFavorites': 'Your Favorites',

      // Bottom Navigation
      'home': 'Home',
      'library': 'Library',
      'playlists': 'Playlists',
      'settings': 'Settings',

      // Library
      'audioFiles': 'Audio Files',
      'videoFiles': 'Video Files',
      'allFiles': 'All Files',
      'scanFiles': 'Scan Files',
      'noFilesFound': 'No files found',
      'scanningFiles': 'Scanning files...',
      'filesFound': '{count} files found',

      // Player
      'nowPlaying': 'Now Playing',
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
      'createPlaylist': 'Create Playlist',
      'playlistName': 'Playlist Name',
      'addToPlaylist': 'Add to Playlist',
      'removeFromPlaylist': 'Remove from Playlist',
      'playlistCreated': 'Playlist created',
      'playlistDeleted': 'Playlist deleted',
      'emptyPlaylist': 'Empty playlist',
      'deletePlaylist': 'Delete Playlist',
      'deletePlaylistConfirmation':
          'Are you sure you want to delete this playlist?',

      // Settings
      'theme': 'Theme',
      'darkMode': 'Dark Mode',
      'lightMode': 'Light Mode',
      'language': 'Language',
      'arabic': 'Arabic',
      'english': 'English',
      'about': 'About',
      'version': 'Version',
      'developer': 'Developer',
      'privacyPolicy': 'Privacy Policy',
      'termsOfService': 'Terms of Service',

      // Error Messages
      'fileNotFound': 'File not found',
      'playbackError': 'Playback error',
      'networkError': 'Network error',
      'permissionDenied': 'Permission denied',
      'storageError': 'Storage error',
      'unknownError': 'Unknown error',

      // File Information
      'fileName': 'File Name',
      'fileSize': 'File Size',
      'filePath': 'File Path',
      'fileType': 'File Type',
      'dateModified': 'Date Modified',
      'dateCreated': 'Date Created',
      'artist': 'Artist',
      'album': 'Album',
      'genre': 'Genre',
      'year': 'Year',

      // Control Buttons
      'playAll': 'Play All',
      'shuffleAll': 'Shuffle All',
      'sortBy': 'Sort By',
      'sortByName': 'Name',
      'sortByDate': 'Date',
      'sortBySize': 'Size',
      'sortByDuration': 'Duration',
      'ascending': 'Ascending',
      'descending': 'Descending',

      // Player States
      'playing': 'Playing',
      'paused': 'Paused',
      'stopped': 'Stopped',
      'loadingMedia': 'Loading media...',
      'buffering': 'Buffering...',
      'ready': 'Ready',

      // Notifications
      'notificationTitle': 'Media Player',
      'notificationSubtitle': 'Now Playing',
      'notificationPlay': 'Play',
      'notificationPause': 'Pause',
      'notificationNext': 'Next',
      'notificationPrevious': 'Previous',

      // Additional Missing Texts
      'libraryManagement': 'Library Management',
      'dataManagement': 'Data Management',
      'cleanLibrary': 'Clean Library',
      'cleanLibrarySubtitle': 'Remove missing files from library',
      'cleanLibraryConfirmation':
          'This will remove all missing files from your library. This action cannot be undone.\n\nContinue?',
      'clean': 'Clean',
      'continue': 'Continue',
      'libraryCleanedSuccessfully': 'Library cleaned successfully',
      'scanComplete': 'Scan Complete',
      'scanCompleteMessage': 'Media scan has been completed successfully.',
      'storageInfo': 'Storage Info',
      'storageInfoSubtitle': 'View storage usage and file statistics',
      'storageInformation': 'Storage Information',
      'totalFiles': 'Total Files',
      'favorites': 'Favorites',
      'clearAllData': 'Clear All Data',
      'clearAllDataSubtitle': 'Remove all playlists and preferences',
      'clearAllDataConfirmation':
          'This will permanently delete all your playlists, favorites, and app data. This action cannot be undone.\n\nAre you sure you want to continue?',
      'clearAll': 'Clear All',
      'allDataClearedSuccessfully': 'All data cleared successfully',
      'rateApp': 'Rate App',
      'rateAppSubtitle': 'Rate us on the app store',
      'ratingFeatureComingSoon': 'Rating feature coming soon!',
      'reportBug': 'Report Bug',
      'reportBugSubtitle': 'Help us improve the app',
      'bugReportingFeatureComingSoon': 'Bug reporting feature coming soon!',
      'privacyPolicySubtitle': 'Read our privacy policy',
      'build': 'Build',
      'appDescription':
          'A modern media player for audio and video files with playlist support.',
      'automaticallyRepeatPlaylists': 'Automatically repeat playlists',
      'randomizePlaybackOrder': 'Randomize playback order',
      'searchForNewMediaFiles': 'Search for new media files on your device',
      'removeMissingFilesFromLibrary': 'Remove missing files from library',
      'viewUsageAndStatistics': 'View storage usage and file statistics',
      'removeAllPlaylistsAndPreferences':
          'Remove all playlists and preferences',
      'readOurPrivacyPolicy': 'Read our privacy policy',
      'rateUsOnAppStore': 'Rate us on the app store',
      'helpUsImproveApp': 'Help us improve the app',
      'times': 'times',
      'playedTimes': 'Played {count} times',
      'noPlaylistsAvailable': 'No playlists available',
      'files': 'files',
      'addedToPlaylist': 'Added to {name}',
      'noSearchResults': 'No search results',
      'noFilePlaying': 'No file playing',
      'addFilesToPlaylist': 'Add Files to {playlistName}',
      'filesSelected': '{count} files selected',
      'noFilesAvailableToAdd': 'No files available to add',
      'addWithCount': 'Add ({count})',
      'addedFilesToPlaylist': 'Added {count} files to playlist',
      'confirmRemoveFromFile': 'Remove \"{fileName}\" from this playlist?',
      'parentDirectory': 'Parent Directory',
      
      // Additional Settings Texts
      'auto_repeat': 'Auto Repeat',
      'automatically_repeat_playlists': 'Automatically repeat playlists',
      'shuffle_mode': 'Shuffle Mode',
      'randomize_playback_order': 'Randomize playback order',
      'scan_files': 'Scan Files',
      'search_for_new_media_files': 'Search for new media files on your device',
      'clean_library': 'Clean Library',
      'remove_missing_files_from_library': 'Remove missing files from library',
      'storage_info': 'Storage Info',
      'view_usage_and_statistics': 'View storage usage and file statistics',
      'data_management': 'Data Management',
      'clear_all_data': 'Clear All Data',
      'remove_all_playlists_and_preferences': 'Remove all playlists and preferences',
      'app_name': 'Media Player',
      'rate_app': 'Rate App',
      'rate_us_on_app_store': 'Rate us on the app store',
      'report_bug': 'Report Bug',
      'help_us_improve_app': 'Help us improve the app',
      'privacy_policy': 'Privacy Policy',
      'read_our_privacy_policy': 'Read our privacy policy',
      
      // Explore Device Screen Texts
      'exploreDevice': 'Explore Device',
      'refresh': 'Refresh',
      'addedToFavorites': 'Added to favorites',
      'removedFromFavorites': 'Removed from favorites',
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
