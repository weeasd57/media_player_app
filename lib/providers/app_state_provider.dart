import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// مزود الحالة العامة للتطبيق
/// يدير الإعدادات العامة والحالة المشتركة بين جميع أجزاء التطبيق
class AppStateProvider extends ChangeNotifier {
  // إعدادات التطبيق
  bool _isFirstLaunch = true;
  bool _isDarkMode = false;
  String _selectedLanguage = 'en';
  double _globalVolume = 1.0;
  bool _isOfflineMode = false;
  
  // حالة التطبيق
  bool _isLoading = false;
  String _loadingMessage = '';
  String? _errorMessage;
  
  // إعدادات التشغيل
  bool _isShuffleEnabled = false;
  bool _isRepeatEnabled = false;
  double _playbackSpeed = 1.0;
  
  // Getters
  bool get isFirstLaunch => _isFirstLaunch;
  bool get isDarkMode => _isDarkMode;
  String get selectedLanguage => _selectedLanguage;
  double get globalVolume => _globalVolume;
  bool get isOfflineMode => _isOfflineMode;
  bool get isLoading => _isLoading;
  String get loadingMessage => _loadingMessage;
  String? get errorMessage => _errorMessage;
  bool get isShuffleEnabled => _isShuffleEnabled;
  bool get isRepeatEnabled => _isRepeatEnabled;
  double get playbackSpeed => _playbackSpeed;

  /// تهيئة المزود وتحميل الإعدادات المحفوظة
  Future<void> initialize() async {
    try {
      setLoading(true, 'تحميل الإعدادات...');
      
      final prefs = await SharedPreferences.getInstance();
      
      _isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'en';
      _globalVolume = prefs.getDouble('globalVolume') ?? 1.0;
      _isOfflineMode = prefs.getBool('isOfflineMode') ?? false;
      _isShuffleEnabled = prefs.getBool('isShuffleEnabled') ?? false;
      _isRepeatEnabled = prefs.getBool('isRepeatEnabled') ?? false;
      _playbackSpeed = prefs.getDouble('playbackSpeed') ?? 1.0;
      
      setLoading(false);
      notifyListeners();
    } catch (e) {
      setError('خطأ في تحميل الإعدادات: $e');
      setLoading(false);
    }
  }

  /// تعيين حالة التحميل
  void setLoading(bool loading, [String message = '']) {
    _isLoading = loading;
    _loadingMessage = message;
    _errorMessage = null;
    notifyListeners();
  }

  /// تعيين رسالة خطأ
  void setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  /// مسح رسالة الخطأ
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// تبديل الوضع المظلم
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _savePreference('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  /// تغيير اللغة
  Future<void> changeLanguage(String languageCode) async {
    if (_selectedLanguage != languageCode) {
      _selectedLanguage = languageCode;
      await _savePreference('selectedLanguage', languageCode);
      notifyListeners();
    }
  }

  /// تعيين مستوى الصوت العام
  Future<void> setGlobalVolume(double volume) async {
    _globalVolume = volume.clamp(0.0, 1.0);
    await _savePreference('globalVolume', _globalVolume);
    notifyListeners();
  }

  /// تبديل الوضع غير المتصل
  Future<void> toggleOfflineMode() async {
    _isOfflineMode = !_isOfflineMode;
    await _savePreference('isOfflineMode', _isOfflineMode);
    notifyListeners();
  }

  /// تبديل وضع الخلط
  Future<void> toggleShuffle() async {
    _isShuffleEnabled = !_isShuffleEnabled;
    await _savePreference('isShuffleEnabled', _isShuffleEnabled);
    notifyListeners();
  }

  /// تبديل وضع التكرار
  Future<void> toggleRepeat() async {
    _isRepeatEnabled = !_isRepeatEnabled;
    await _savePreference('isRepeatEnabled', _isRepeatEnabled);
    notifyListeners();
  }

  /// تعيين سرعة التشغيل
  Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed = speed.clamp(0.25, 3.0);
    await _savePreference('playbackSpeed', _playbackSpeed);
    notifyListeners();
  }

  /// تعيين أن التطبيق لم يعد في الإطلاق الأول
  Future<void> setNotFirstLaunch() async {
    _isFirstLaunch = false;
    await _savePreference('isFirstLaunch', false);
    notifyListeners();
  }

  /// حفظ إعداد في SharedPreferences
  Future<void> _savePreference(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      }
    } catch (e) {
      setError('خطأ في حفظ الإعداد $key: $e');
    }
  }

  /// إعادة تعيين جميع الإعدادات للقيم الافتراضية
  Future<void> resetToDefaults() async {
    try {
      setLoading(true, 'إعادة تعيين الإعدادات...');
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      _isFirstLaunch = true;
      _isDarkMode = false;
      _selectedLanguage = 'en';
      _globalVolume = 1.0;
      _isOfflineMode = false;
      _isShuffleEnabled = false;
      _isRepeatEnabled = false;
      _playbackSpeed = 1.0;
      
      setLoading(false);
      notifyListeners();
    } catch (e) {
      setError('خطأ في إعادة تعيين الإعدادات: $e');
      setLoading(false);
    }
  }

  /// تصدير الإعدادات كـ JSON
  Map<String, dynamic> exportSettings() {
    return {
      'isDarkMode': _isDarkMode,
      'selectedLanguage': _selectedLanguage,
      'globalVolume': _globalVolume,
      'isOfflineMode': _isOfflineMode,
      'isShuffleEnabled': _isShuffleEnabled,
      'isRepeatEnabled': _isRepeatEnabled,
      'playbackSpeed': _playbackSpeed,
    };
  }

  /// استيراد الإعدادات من JSON
  Future<void> importSettings(Map<String, dynamic> settings) async {
    try {
      setLoading(true, 'استيراد الإعدادات...');
      
      if (settings.containsKey('isDarkMode')) {
        _isDarkMode = settings['isDarkMode'] as bool;
        await _savePreference('isDarkMode', _isDarkMode);
      }
      
      if (settings.containsKey('selectedLanguage')) {
        _selectedLanguage = settings['selectedLanguage'] as String;
        await _savePreference('selectedLanguage', _selectedLanguage);
      }
      
      if (settings.containsKey('globalVolume')) {
        _globalVolume = (settings['globalVolume'] as num).toDouble();
        await _savePreference('globalVolume', _globalVolume);
      }
      
      if (settings.containsKey('isOfflineMode')) {
        _isOfflineMode = settings['isOfflineMode'] as bool;
        await _savePreference('isOfflineMode', _isOfflineMode);
      }
      
      if (settings.containsKey('isShuffleEnabled')) {
        _isShuffleEnabled = settings['isShuffleEnabled'] as bool;
        await _savePreference('isShuffleEnabled', _isShuffleEnabled);
      }
      
      if (settings.containsKey('isRepeatEnabled')) {
        _isRepeatEnabled = settings['isRepeatEnabled'] as bool;
        await _savePreference('isRepeatEnabled', _isRepeatEnabled);
      }
      
      if (settings.containsKey('playbackSpeed')) {
        _playbackSpeed = (settings['playbackSpeed'] as num).toDouble();
        await _savePreference('playbackSpeed', _playbackSpeed);
      }
      
      setLoading(false);
      notifyListeners();
    } catch (e) {
      setError('خطأ في استيراد الإعدادات: $e');
      setLoading(false);
    }
  }
}