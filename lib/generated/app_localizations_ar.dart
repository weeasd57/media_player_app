// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مشغل الوسائط';

  @override
  String get goodMorning => 'صباح الخير!';

  @override
  String get goodAfternoon => 'مساء الخير!';

  @override
  String get goodEvening => 'مساء الخير!';

  @override
  String get yourLibrary => 'مكتبتك';

  @override
  String get audioFiles => 'ملفات الصوت';

  @override
  String get videoFiles => 'ملفات الفيديو';

  @override
  String get favorites => 'المفضلة';

  @override
  String get playlists => 'قوائم التشغيل';

  @override
  String get quickActions => 'الإجراءات السريعة';

  @override
  String get scanFiles => 'فحص الملفات';

  @override
  String get createPlaylist => 'إنشاء قائمة تشغيل';

  @override
  String get recentlyPlayed => 'تم تشغيلها مؤخراً';

  @override
  String get yourFavorites => 'مفضلاتك';

  @override
  String get yourPlaylists => 'قوائم التشغيل الخاصة بك';

  @override
  String get loadingLibrary => 'جاري تحميل مكتبة الوسائط...';

  @override
  String get scanComplete => 'اكتمل الفحص';

  @override
  String get scanFailed => 'فشل الفحص';

  @override
  String scanError(Object error) {
    return 'خطأ في الفحص: $error';
  }

  @override
  String filesFound(Object newFiles, Object totalFiles) {
    return 'تم العثور على $totalFiles ملف\\nتمت إضافة $newFiles ملف جديد';
  }

  @override
  String get playlistCreated => 'تم إنشاء قائمة التشغيل بنجاح';

  @override
  String get searchMediaFiles => 'البحث في ملفات الوسائط';

  @override
  String get createNewPlaylist => 'إنشاء قائمة تشغيل جديدة';

  @override
  String get playlistName => 'اسم قائمة التشغيل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get create => 'إنشاء';

  @override
  String get ok => 'موافق';

  @override
  String get done => 'تم';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get settings => 'الإعدادات';

  @override
  String get library => 'المكتبة';

  @override
  String get scanMediaFiles => 'فحص ملفات الوسائط';

  @override
  String get scanMediaFilesDesc => 'البحث عن ملفات وسائط جديدة على جهازك';

  @override
  String get cleanLibrary => 'تنظيف المكتبة';

  @override
  String get cleanLibraryDesc => 'إزالة الملفات المفقودة من المكتبة';

  @override
  String get storageInfo => 'معلومات التخزين';

  @override
  String get storageInfoDesc => 'عرض استخدام التخزين وإحصائيات الملفات';

  @override
  String get playback => 'التشغيل';

  @override
  String get autoRepeat => 'التكرار التلقائي';

  @override
  String get autoRepeatDesc => 'تكرار قوائم التشغيل تلقائياً';

  @override
  String get shuffleMode => 'وضع الخلط';

  @override
  String get shuffleModeDesc => 'ترتيب التشغيل عشوائياً';

  @override
  String get dataManagement => 'إدارة البيانات';

  @override
  String get clearAllData => 'مسح جميع البيانات';

  @override
  String get clearAllDataDesc => 'إزالة جميع قوائم التشغيل والتفضيلات';

  @override
  String get about => 'حول';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get rateAppDesc => 'قيمنا في متجر التطبيقات';

  @override
  String get reportBug => 'الإبلاغ عن خطأ';

  @override
  String get reportBugDesc => 'ساعدنا في تحسين التطبيق';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get privacyPolicyDesc => 'اقرأ سياسة الخصوصية الخاصة بنا';

  @override
  String get scanningFiles => 'فحص الملفات';

  @override
  String get preparingToScan => 'جاري التحضير للفحص...';

  @override
  String get cleanLibraryConfirm =>
      'سيؤدي هذا إلى إزالة جميع الملفات المفقودة من مكتبتك. لا يمكن التراجع عن هذا الإجراء.\\n\\nهل تريد المتابعة؟';

  @override
  String get clean => 'تنظيف';

  @override
  String removedMissingFiles(Object count) {
    return 'تم إزالة $count ملف مفقود';
  }

  @override
  String get storageInformation => 'معلومات التخزين';

  @override
  String get totalFiles => 'إجمالي الملفات';

  @override
  String get clearAllDataConfirm =>
      'سيؤدي هذا إلى حذف جميع قوائم التشغيل والمفضلات وبيانات التطبيق نهائياً. لا يمكن التراجع عن هذا الإجراء.\\n\\nهل أنت متأكد من أنك تريد المتابعة؟';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get allDataCleared => 'تم مسح جميع البيانات بنجاح';

  @override
  String bass(Object value) {
    return 'الباس: $value';
  }

  @override
  String treble(Object value) {
    return 'الصوت العالي: $value';
  }

  @override
  String get appInformation => 'معلومات التطبيق';

  @override
  String get version => 'الإصدار: 1.0.0';

  @override
  String get build => 'البناء: 1';

  @override
  String get appDescription =>
      'مشغل وسائط حديث لملفات الصوت والفيديو مع دعم قوائم التشغيل.';

  @override
  String get ratingFeatureComingSoon => 'ميزة التقييم قادمة قريباً!';

  @override
  String get bugReportingComingSoon => 'ميزة الإبلاغ عن الأخطاء قادمة قريباً!';

  @override
  String get privacyPolicyTitle => 'سياسة الخصوصية';

  @override
  String get privacyPolicyContent =>
      'سياسة الخصوصية\\n\\nتم تصميم تطبيق مشغل الوسائط هذا لاحترام خصوصيتك. يتم تخزين جميع ملفات الوسائط محلياً على جهازك ولا يتم نقلها إلى أي خوادم خارجية.\\n\\nجمع البيانات:\\n• نحن لا نجمع أي معلومات شخصية\\n• يتم تخزين مسارات الملفات والبيانات الوصفية محلياً فقط\\n• لا يتم مشاركة البيانات مع أطراف ثالثة\\n\\nالصلاحيات:\\n• الوصول للتخزين: مطلوب لفحص وتشغيل ملفات الوسائط\\n• لا يتم طلب صلاحيات الشبكة\\n\\nتبقى مكتبة الوسائط وقوائم التشغيل خاصة تماماً وتحت سيطرتك.';

  @override
  String filesCount(Object count) {
    return '$count ملف';
  }

  @override
  String get storagePermissionRequired => 'صلاحية التخزين مطلوبة';

  @override
  String permissionError(Object error) {
    return 'خطأ في الصلاحيات: $error';
  }

  @override
  String get noMediaFound => 'لم يتم العثور على وسائط';

  @override
  String get noPlaylistsYet => 'ليس لديك قوائم تشغيل بعد';

  @override
  String get createFirstPlaylist =>
      'أنشئ قائمة التشغيل الأولى لتنظيم ملفات الوسائط المفضلة لديك';

  @override
  String get playAll => 'تشغيل الكل';

  @override
  String get edit => 'تعديل';

  @override
  String get duplicate => 'تكرار';

  @override
  String get delete => 'حذف';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String daysAgo(Object days) {
    return 'منذ $days أيام';
  }

  @override
  String get playlistIsEmpty => 'قائمة التشغيل فارغة';

  @override
  String get addSomeFiles => 'أضف بعض الملفات للبدء';

  @override
  String get playlistUpdated => 'تم تحديث قائمة التشغيل';

  @override
  String get playlistDuplicated => 'تم تكرار قائمة التشغيل';

  @override
  String get deletePlaylist => 'حذف قائمة التشغيل';

  @override
  String deletePlaylistConfirmation(Object playlistName) {
    return 'هل أنت متأكد من أنك تريد حذف \'$playlistName\'؟';
  }

  @override
  String get playlistDeleted => 'تم حذف قائمة التشغيل';

  @override
  String get descriptionOptional => 'الوصف (اختياري)';

  @override
  String get editPlaylist => 'تعديل قائمة التشغيل';

  @override
  String get save => 'حفظ';

  @override
  String get removeFromPlaylist => 'إزالة من قائمة التشغيل';

  @override
  String get addToPlaylist => 'إضافة إلى قائمة التشغيل';

  @override
  String get removedFromPlaylist => 'تم إزالة الملف من قائمة التشغيل';

  @override
  String addedToPlaylist(Object name) {
    return 'تم إضافة الملف إلى قائمة التشغيل';
  }

  @override
  String get noFilePlaying => 'No file playing';

  @override
  String get noSearchResults => 'No search results';

  @override
  String get removeFromFavorites => 'إزالة من المفضلة';

  @override
  String get addToFavorites => 'إضافة إلى المفضلة';

  @override
  String get removedFromFavorites => 'تم إزالة الملف من المفضلة';

  @override
  String get addedToFavorites => 'تم إضافة الملف إلى المفضلة';

  @override
  String get deleteFile => 'حذف الملف';

  @override
  String get searchFiles => 'البحث في الملفات';

  @override
  String get searchHint => 'البحث في ملفات الوسائط...';

  @override
  String get error => 'خطأ';

  @override
  String get ready => 'جاهز';

  @override
  String get buffering => 'جاري التخزين المؤقت...';

  @override
  String get playing => 'قيد التشغيل';

  @override
  String get paused => 'متوقف';

  @override
  String get selectAudioFile => 'اختر ملف صوتي';

  @override
  String get upNext => 'قيد التشغيل التالي';

  @override
  String get currentVideo => 'الفيديو الحالي';

  @override
  String get dimensions => 'الأبعاد';

  @override
  String get selectVideoFile => 'اختر ملف فيديو';

  @override
  String playedXTimes(Object count) {
    return 'Played $count times';
  }

  @override
  String addFilesToPlaylist(Object playlistName) {
    return 'Add Files to $playlistName';
  }

  @override
  String filesSelected(Object count) {
    return '$count files selected';
  }

  @override
  String get noFilesAvailableToAdd => 'No files available to add';

  @override
  String addWithCount(Object count) {
    return 'Add ($count)';
  }

  @override
  String addedFilesToPlaylist(Object count) {
    return 'Added $count files to playlist';
  }

  @override
  String confirmRemoveFromFile(Object fileName) {
    return 'Remove \"$fileName\" from this playlist?';
  }
}
