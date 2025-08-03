import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar', 'SA'); // Arabic as default
  static const String _localeKey = 'selected_locale';
  
  Locale get locale => _locale;
  
  bool get isArabic => _locale.languageCode == 'ar';
  
  LocaleProvider() {
    _loadLocale();
  }
  
  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = prefs.getString(_localeKey) ?? 'ar';
      _locale = localeCode == 'ar' 
        ? const Locale('ar', 'SA') 
        : const Locale('en', 'US');
      notifyListeners();
    } catch (e) {
      // If SharedPreferences fails, keep default Arabic locale
      _locale = const Locale('ar', 'SA');
    }
  }
  
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
    } catch (e) {
      // Handle SharedPreferences error silently
      debugPrint('Error saving locale: $e');
    }
  }
  
  Future<void> toggleLocale() async {
    final newLocale = _locale.languageCode == 'ar' 
      ? const Locale('en', 'US')
      : const Locale('ar', 'SA');
    await setLocale(newLocale);
  }
  
  // Get localized text based on current locale
  String getLocalizedText(String arabicText, String englishText) {
    return isArabic ? arabicText : englishText;
  }
  
  // Common UI texts
  String get appTitle => isArabic ? 'مشغل الوسائط' : 'Media Player';
  String get settings => isArabic ? 'الإعدادات' : 'Settings';
  String get home => isArabic ? 'الرئيسية' : 'Home';
  String get music => isArabic ? 'الموسيقى' : 'Music';
  String get videos => isArabic ? 'الفيديوهات' : 'Videos';
  String get playlists => isArabic ? 'قوائم التشغيل' : 'Playlists';
  String get favorites => isArabic ? 'المفضلة' : 'Favorites';
  String get darkMode => isArabic ? 'الوضع الداكن' : 'Dark Mode';
  String get lightMode => isArabic ? 'الوضع الفاتح' : 'Light Mode';
  String get language => isArabic ? 'اللغة' : 'Language';
  String get play => isArabic ? 'تشغيل' : 'Play';
  String get pause => isArabic ? 'إيقاف مؤقت' : 'Pause';
  String get stop => isArabic ? 'إيقاف' : 'Stop';
  String get next => isArabic ? 'التالي' : 'Next';
  String get previous => isArabic ? 'السابق' : 'Previous';
  String get shuffle => isArabic ? 'خلط' : 'Shuffle';
  String get repeat => isArabic ? 'تكرار' : 'Repeat';
  String get volume => isArabic ? 'مستوى الصوت' : 'Volume';
  String get nowPlaying => isArabic ? 'قيد التشغيل الآن' : 'Now Playing';
  String get queue => isArabic ? 'قائمة الانتظار' : 'Queue';
  String get search => isArabic ? 'بحث' : 'Search';
  String get addToPlaylist => isArabic ? 'إضافة إلى قائمة التشغيل' : 'Add to Playlist';
  String get createPlaylist => isArabic ? 'إنشاء قائمة تشغيل' : 'Create Playlist';
  String get deletePlaylist => isArabic ? 'حذف قائمة التشغيل' : 'Delete Playlist';
  String get noMediaFound => isArabic ? 'لم يتم العثور على وسائط' : 'No Media Found';
  String get loading => isArabic ? 'جاري التحميل...' : 'Loading...';
  String get error => isArabic ? 'خطأ' : 'Error';
  String get retry => isArabic ? 'إعادة المحاولة' : 'Retry';
  String get cancel => isArabic ? 'إلغاء' : 'Cancel';
  String get ok => isArabic ? 'موافق' : 'OK';
  String get yes => isArabic ? 'نعم' : 'Yes';
  String get no => isArabic ? 'لا' : 'No';
  String get delete => isArabic ? 'حذف' : 'Delete';
  String get edit => isArabic ? 'تعديل' : 'Edit';
  String get save => isArabic ? 'حفظ' : 'Save';
  String get close => isArabic ? 'إغلاق' : 'Close';
}