import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
// import 'package:crypto/crypto.dart'; // سيتم إضافتها لاحقاً

/// نوع البيانات المخزنة في الكاش
enum CacheType {
  image,
  audio,
  video,
  metadata,
  playlist,
  settings,
  temporary,
}

/// عنصر الكاش
class CacheItem {
  final String key;
  final dynamic data;
  final CacheType type;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final int size; // بالبايت
  final Map<String, dynamic>? metadata;

  CacheItem({
    required this.key,
    required this.data,
    required this.type,
    required this.createdAt,
    this.expiresAt,
    required this.size,
    this.metadata,
  });

  /// التحقق من انتهاء صلاحية العنصر
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// التحقق من صحة العنصر
  bool get isValid => !isExpired;

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'data': data,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'size': size,
      'metadata': metadata,
    };
  }

  /// إنشاء من JSON
  factory CacheItem.fromJson(Map<String, dynamic> json) {
    return CacheItem(
      key: json['key'],
      data: json['data'],
      type: CacheType.values.firstWhere((e) => e.name == json['type']),
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      size: json['size'],
      metadata: json['metadata'],
    );
  }
}

/// إحصائيات الكاش
class CacheStatistics {
  final int totalItems;
  final int totalSize; // بالبايت
  final int expiredItems;
  final Map<CacheType, int> itemsByType;
  final Map<CacheType, int> sizeByType;
  final DateTime lastCleanup;

  CacheStatistics({
    required this.totalItems,
    required this.totalSize,
    required this.expiredItems,
    required this.itemsByType,
    required this.sizeByType,
    required this.lastCleanup,
  });

  /// الحجم بالميجابايت
  double get totalSizeMB => totalSize / (1024 * 1024);

  /// نسبة العناصر المنتهية الصلاحية
  double get expiredPercentage => totalItems > 0 ? (expiredItems / totalItems) * 100 : 0;
}

/// مزود إدارة الكاش والبيانات المؤقتة
class CacheProvider extends ChangeNotifier {
  final Map<String, CacheItem> _cache = {};
  
  // إعدادات الكاش
  int _maxCacheSize = 100 * 1024 * 1024; // 100 MB
  int _maxItems = 1000;
  Duration _defaultExpiration = const Duration(hours: 24);
  bool _autoCleanup = true;
  Duration _cleanupInterval = const Duration(hours: 6);
  
  // إحصائيات
  DateTime _lastCleanup = DateTime.now();
  int _totalHits = 0;
  int _totalMisses = 0;
  
  // مؤقت التنظيف التلقائي
  Timer? _cleanupTimer;

  // Getters
  int get totalItems => _cache.length;
  int get totalSize => _cache.values.fold(0, (sum, item) => sum + item.size);
  double get totalSizeMB => totalSize / (1024 * 1024);
  int get expiredItems => _cache.values.where((item) => item.isExpired).length;
  double get hitRate => _totalHits + _totalMisses > 0 ? _totalHits / (_totalHits + _totalMisses) : 0;
  bool get isAutoCleanupEnabled => _autoCleanup;
  int get maxCacheSize => _maxCacheSize;
  int get maxItems => _maxItems;

  /// تهيئة مزود الكاش
  Future<void> initialize() async {
    try {
      await _loadCacheFromStorage();
      
      if (_autoCleanup) {
        _startAutoCleanup();
      }
      
      debugPrint('🗄️ Cache provider initialized with ${_cache.length} items');
    } catch (e) {
      debugPrint('❌ Error initializing cache provider: $e');
    }
  }

  /// بدء التنظيف التلقائي
  void _startAutoCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(_cleanupInterval, (_) {
      _performAutoCleanup();
    });
  }

  /// إيقاف التنظيف التلقائي
  void _stopAutoCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  /// إضافة عنصر إلى الكاش
  Future<void> put(
    String key,
    dynamic data, {
    CacheType type = CacheType.temporary,
    Duration? expiration,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // حساب حجم البيانات
      final size = _calculateDataSize(data);
      
      // التحقق من الحدود
      if (size > _maxCacheSize) {
        debugPrint('⚠️ Data too large for cache: ${size / (1024 * 1024)} MB');
        return;
      }

      // إنشاء عنصر الكاش
      final item = CacheItem(
        key: key,
        data: data,
        type: type,
        createdAt: DateTime.now(),
        expiresAt: expiration != null 
            ? DateTime.now().add(expiration)
            : DateTime.now().add(_defaultExpiration),
        size: size,
        metadata: metadata,
      );

      // إضافة العنصر
      _cache[key] = item;

      // التحقق من الحدود وتنظيف الكاش إذا لزم الأمر
      await _enforceConstraints();

      // حفظ في التخزين المحلي للعناصر المهمة
      if (type != CacheType.temporary) {
        await _saveCacheToStorage();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error adding item to cache: $e');
    }
  }

  /// الحصول على عنصر من الكاش
  T? get<T>(String key) {
    try {
      final item = _cache[key];
      
      if (item == null) {
        _totalMisses++;
        return null;
      }

      if (item.isExpired) {
        _cache.remove(key);
        _totalMisses++;
        return null;
      }

      _totalHits++;
      return item.data as T?;
    } catch (e) {
      debugPrint('❌ Error getting item from cache: $e');
      _totalMisses++;
      return null;
    }
  }

  /// التحقق من وجود عنصر في الكاش
  bool contains(String key) {
    final item = _cache[key];
    return item != null && item.isValid;
  }

  /// حذف عنصر من الكاش
  Future<void> remove(String key) async {
    try {
      _cache.remove(key);
      await _saveCacheToStorage();
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error removing item from cache: $e');
    }
  }

  /// مسح جميع عناصر الكاش
  Future<void> clear() async {
    try {
      _cache.clear();
      await _clearCacheFromStorage();
      _totalHits = 0;
      _totalMisses = 0;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error clearing cache: $e');
    }
  }

  /// مسح عناصر الكاش حسب النوع
  Future<void> clearByType(CacheType type) async {
    try {
      _cache.removeWhere((key, item) => item.type == type);
      await _saveCacheToStorage();
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error clearing cache by type: $e');
    }
  }

  /// تنظيف العناصر المنتهية الصلاحية
  Future<int> cleanupExpired() async {
    try {
      final expiredKeys = _cache.entries
          .where((entry) => entry.value.isExpired)
          .map((entry) => entry.key)
          .toList();

      for (final key in expiredKeys) {
        _cache.remove(key);
      }

      _lastCleanup = DateTime.now();
      await _saveCacheToStorage();
      notifyListeners();

      debugPrint('🧹 Cleaned up ${expiredKeys.length} expired cache items');
      return expiredKeys.length;
    } catch (e) {
      debugPrint('❌ Error cleaning up expired items: $e');
      return 0;
    }
  }

  /// تنظيف تلقائي
  Future<void> _performAutoCleanup() async {
    await cleanupExpired();
    
    // إذا كان الكاش لا يزال كبيراً، احذف العناصر الأقدم
    if (totalSize > _maxCacheSize * 0.8) {
      await _cleanupOldestItems();
    }
  }

  /// حذف العناصر الأقدم
  Future<void> _cleanupOldestItems() async {
    try {
      final sortedItems = _cache.entries.toList()
        ..sort((a, b) => a.value.createdAt.compareTo(b.value.createdAt));

      final itemsToRemove = (sortedItems.length * 0.2).ceil(); // احذف 20%
      
      for (int i = 0; i < itemsToRemove && i < sortedItems.length; i++) {
        _cache.remove(sortedItems[i].key);
      }

      await _saveCacheToStorage();
      notifyListeners();

      debugPrint('🧹 Cleaned up $itemsToRemove oldest cache items');
    } catch (e) {
      debugPrint('❌ Error cleaning up oldest items: $e');
    }
  }

  /// فرض القيود على الكاش
  Future<void> _enforceConstraints() async {
    // التحقق من عدد العناصر
    if (_cache.length > _maxItems) {
      await _cleanupOldestItems();
    }

    // التحقق من الحجم
    if (totalSize > _maxCacheSize) {
      await _cleanupOldestItems();
    }
  }

  /// حساب حجم البيانات
  int _calculateDataSize(dynamic data) {
    try {
      if (data is String) {
        return data.length * 2; // UTF-16
      } else if (data is Uint8List) {
        return data.length;
      } else if (data is List) {
        return data.length * 8; // تقدير تقريبي
      } else if (data is Map) {
        final jsonString = jsonEncode(data);
        return jsonString.length * 2;
      } else {
        return 64; // حجم افتراضي
      }
    } catch (e) {
      return 64; // حجم افتراضي في حالة الخطأ
    }
  }

  /// تحميل الكاش من التخزين المحلي
  Future<void> _loadCacheFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = prefs.getString('app_cache');
      
      if (cacheData != null) {
        final Map<String, dynamic> cacheMap = jsonDecode(cacheData);
        
        for (final entry in cacheMap.entries) {
          try {
            final item = CacheItem.fromJson(entry.value);
            if (item.isValid) {
              _cache[entry.key] = item;
            }
          } catch (e) {
            debugPrint('⚠️ Error loading cache item ${entry.key}: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error loading cache from storage: $e');
    }
  }

  /// حفظ الكاش في التخزين المحلي
  Future<void> _saveCacheToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // حفظ العناصر غير المؤقتة فقط
      final persistentCache = Map<String, dynamic>.fromEntries(
        _cache.entries
            .where((entry) => entry.value.type != CacheType.temporary)
            .map((entry) => MapEntry(entry.key, entry.value.toJson())),
      );
      
      await prefs.setString('app_cache', jsonEncode(persistentCache));
    } catch (e) {
      debugPrint('❌ Error saving cache to storage: $e');
    }
  }

  /// مسح الكاش من التخزين المحلي
  Future<void> _clearCacheFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('app_cache');
    } catch (e) {
      debugPrint('❌ Error clearing cache from storage: $e');
    }
  }

  /// تعيين إعدادات الكاش
  void updateSettings({
    int? maxCacheSize,
    int? maxItems,
    Duration? defaultExpiration,
    bool? autoCleanup,
    Duration? cleanupInterval,
  }) {
    if (maxCacheSize != null && maxCacheSize > 0) {
      _maxCacheSize = maxCacheSize;
    }
    
    if (maxItems != null && maxItems > 0) {
      _maxItems = maxItems;
    }
    
    if (defaultExpiration != null) {
      _defaultExpiration = defaultExpiration;
    }
    
    if (autoCleanup != null) {
      _autoCleanup = autoCleanup;
      if (_autoCleanup) {
        _startAutoCleanup();
      } else {
        _stopAutoCleanup();
      }
    }
    
    if (cleanupInterval != null) {
      _cleanupInterval = cleanupInterval;
      if (_autoCleanup) {
        _startAutoCleanup(); // إعادة تشغيل بالفترة الجديدة
      }
    }
    
    notifyListeners();
  }

  /// الحصول على إحصائيات الكاش
  CacheStatistics getStatistics() {
    final itemsByType = <CacheType, int>{};
    final sizeByType = <CacheType, int>{};
    
    for (final type in CacheType.values) {
      itemsByType[type] = 0;
      sizeByType[type] = 0;
    }
    
    for (final item in _cache.values) {
      itemsByType[item.type] = (itemsByType[item.type] ?? 0) + 1;
      sizeByType[item.type] = (sizeByType[item.type] ?? 0) + item.size;
    }
    
    return CacheStatistics(
      totalItems: totalItems,
      totalSize: totalSize,
      expiredItems: expiredItems,
      itemsByType: itemsByType,
      sizeByType: sizeByType,
      lastCleanup: _lastCleanup,
    );
  }

  /// إنشاء مفتاح كاش من البيانات
  String generateKey(String prefix, Map<String, dynamic> params) {
    final sortedParams = Map.fromEntries(
      params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    
    final paramString = jsonEncode(sortedParams);
    final combinedString = '$prefix:$paramString';
    
    // استخدام hash code بسيط بدلاً من SHA256
    return combinedString.hashCode.abs().toString();
  }

  /// تصدير الكاش كـ JSON
  Map<String, dynamic> exportCache() {
    return {
      'items': _cache.map((key, item) => MapEntry(key, item.toJson())),
      'statistics': getStatistics(),
      'settings': {
        'maxCacheSize': _maxCacheSize,
        'maxItems': _maxItems,
        'defaultExpiration': _defaultExpiration.inMilliseconds,
        'autoCleanup': _autoCleanup,
        'cleanupInterval': _cleanupInterval.inMilliseconds,
      },
    };
  }

  @override
  void dispose() {
    _stopAutoCleanup();
    super.dispose();
  }
}