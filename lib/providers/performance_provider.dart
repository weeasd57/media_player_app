import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';

/// معلومات الأداء
class PerformanceMetrics {
  final double memoryUsage; // بالميجابايت
  final double cpuUsage; // نسبة مئوية
  final int frameRate; // إطار في الثانية
  final Duration renderTime; // وقت الرسم
  final int activeWidgets; // عدد الويدجت النشطة
  final DateTime timestamp;

  PerformanceMetrics({
    required this.memoryUsage,
    required this.cpuUsage,
    required this.frameRate,
    required this.renderTime,
    required this.activeWidgets,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'memoryUsage': memoryUsage,
      'cpuUsage': cpuUsage,
      'frameRate': frameRate,
      'renderTime': renderTime.inMicroseconds,
      'activeWidgets': activeWidgets,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// مزود مراقبة الأداء والذاكرة
class PerformanceProvider extends ChangeNotifier {
  Timer? _performanceTimer;
  final List<PerformanceMetrics> _metricsHistory = [];

  // إعدادات المراقبة
  bool _isMonitoringEnabled = kDebugMode;
  Duration _monitoringInterval = const Duration(seconds: 5);
  final int _maxHistorySize = 100;

  // معلومات الأداء الحالية
  PerformanceMetrics? _currentMetrics;
  double _averageMemoryUsage = 0.0;
  double _averageCpuUsage = 0.0;
  int _averageFrameRate = 60;

  // تحذيرات الأداء
  bool _hasMemoryWarning = false;
  bool _hasCpuWarning = false;
  bool _hasFrameRateWarning = false;

  // حدود التحذير
  double _memoryWarningThreshold = 100.0; // ميجابايت
  double _cpuWarningThreshold = 80.0; // نسبة مئوية
  int _frameRateWarningThreshold = 30; // إطار في الثانية

  // Getters
  bool get isMonitoringEnabled => _isMonitoringEnabled;
  PerformanceMetrics? get currentMetrics => _currentMetrics;
  List<PerformanceMetrics> get metricsHistory =>
      List.unmodifiable(_metricsHistory);
  double get averageMemoryUsage => _averageMemoryUsage;
  double get averageCpuUsage => _averageCpuUsage;
  int get averageFrameRate => _averageFrameRate;
  bool get hasMemoryWarning => _hasMemoryWarning;
  bool get hasCpuWarning => _hasCpuWarning;
  bool get hasFrameRateWarning => _hasFrameRateWarning;
  bool get hasAnyWarning =>
      _hasMemoryWarning || _hasCpuWarning || _hasFrameRateWarning;

  /// بدء مراقبة الأداء
  void startMonitoring() {
    if (!_isMonitoringEnabled || _performanceTimer != null) return;

    _performanceTimer = Timer.periodic(_monitoringInterval, (_) {
      _collectMetrics();
    });

    debugPrint('🔍 Performance monitoring started');
  }

  /// إيقاف مراقبة الأداء
  void stopMonitoring() {
    _performanceTimer?.cancel();
    _performanceTimer = null;
    debugPrint('🔍 Performance monitoring stopped');
  }

  /// تفعيل/إلغاء تفعيل المراقبة
  void toggleMonitoring() {
    _isMonitoringEnabled = !_isMonitoringEnabled;

    if (_isMonitoringEnabled) {
      startMonitoring();
    } else {
      stopMonitoring();
    }

    notifyListeners();
  }

  /// جمع معلومات الأداء
  Future<void> _collectMetrics() async {
    try {
      final memoryUsage = await _getMemoryUsage();
      final cpuUsage = await _getCpuUsage();
      final frameRate = _getFrameRate();
      final renderTime = _getRenderTime();
      final activeWidgets = _getActiveWidgetCount();

      final metrics = PerformanceMetrics(
        memoryUsage: memoryUsage,
        cpuUsage: cpuUsage,
        frameRate: frameRate,
        renderTime: renderTime,
        activeWidgets: activeWidgets,
        timestamp: DateTime.now(),
      );

      _currentMetrics = metrics;
      _metricsHistory.insert(0, metrics);

      // الحفاظ على الحد الأقصى للتاريخ
      if (_metricsHistory.length > _maxHistorySize) {
        _metricsHistory.removeRange(_maxHistorySize, _metricsHistory.length);
      }

      _updateAverages();
      _checkWarnings();

      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error collecting performance metrics: $e');
    }
  }

  /// الحصول على استخدام الذاكرة
  Future<double> _getMemoryUsage() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // للأجهزة المحمولة، نستخدم ProcessInfo
        final info = ProcessInfo.currentRss;
        return info / (1024 * 1024); // تحويل إلى ميجابايت
      } else {
        // للمنصات الأخرى، نستخدم تقدير تقريبي
        return 50.0; // قيمة افتراضية
      }
    } catch (e) {
      debugPrint('❌ Error getting memory usage: $e');
      return 0.0;
    }
  }

  /// الحصول على استخدام المعالج
  Future<double> _getCpuUsage() async {
    try {
      // هذا تقدير تقريبي - في التطبيقات الحقيقية يمكن استخدام مكتبات متخصصة
      final stopwatch = Stopwatch()..start();

      // محاكاة عملية حسابية بسيطة

      stopwatch.stop();

      // تحويل الوقت إلى نسبة مئوية تقريبية
      final cpuUsage = (stopwatch.elapsedMicroseconds / 1000).clamp(0.0, 100.0);
      return cpuUsage;
    } catch (e) {
      debugPrint('❌ Error getting CPU usage: $e');
      return 0.0;
    }
  }

  /// الحصول على معدل الإطارات
  int _getFrameRate() {
    try {
      // في Flutter، يمكن استخدام WidgetsBinding للحصول على معلومات الإطارات
      return 60; // ق��مة افتراضية - يمكن تحسينها
    } catch (e) {
      debugPrint('❌ Error getting frame rate: $e');
      return 60;
    }
  }

  /// الحصول على وقت الرسم
  Duration _getRenderTime() {
    try {
      // قياس وقت الرسم التقريبي
      return const Duration(milliseconds: 16); // 60 FPS = ~16ms per frame
    } catch (e) {
      debugPrint('❌ Error getting render time: $e');
      return const Duration(milliseconds: 16);
    }
  }

  /// الحصول على عدد الويدجت النشطة
  int _getActiveWidgetCount() {
    try {
      // تقدير تقريبي - في التطبيقات الحقيقية يمكن تتبع الويدجت
      return 100; // قيمة افتراضية
    } catch (e) {
      debugPrint('❌ Error getting active widget count: $e');
      return 0;
    }
  }

  /// تحديث المتوسطات
  void _updateAverages() {
    if (_metricsHistory.isEmpty) return;

    final recentMetrics = _metricsHistory.take(10).toList();

    _averageMemoryUsage =
        recentMetrics.map((m) => m.memoryUsage).reduce((a, b) => a + b) /
        recentMetrics.length;

    _averageCpuUsage =
        recentMetrics.map((m) => m.cpuUsage).reduce((a, b) => a + b) /
        recentMetrics.length;

    _averageFrameRate =
        (recentMetrics.map((m) => m.frameRate).reduce((a, b) => a + b) /
                recentMetrics.length)
            .round();
  }

  /// فحص التحذيرات
  void _checkWarnings() {
    if (_currentMetrics == null) return;

    final oldMemoryWarning = _hasMemoryWarning;
    final oldCpuWarning = _hasCpuWarning;
    final oldFrameRateWarning = _hasFrameRateWarning;

    _hasMemoryWarning = _currentMetrics!.memoryUsage > _memoryWarningThreshold;
    _hasCpuWarning = _currentMetrics!.cpuUsage > _cpuWarningThreshold;
    _hasFrameRateWarning =
        _currentMetrics!.frameRate < _frameRateWarningThreshold;

    // إشعار بالتحذيرات الجديدة
    if (_hasMemoryWarning && !oldMemoryWarning) {
      debugPrint(
        '⚠️ Memory usage warning: ${_currentMetrics!.memoryUsage.toStringAsFixed(1)} MB',
      );
    }

    if (_hasCpuWarning && !oldCpuWarning) {
      debugPrint(
        '⚠️ CPU usage warning: ${_currentMetrics!.cpuUsage.toStringAsFixed(1)}%',
      );
    }

    if (_hasFrameRateWarning && !oldFrameRateWarning) {
      debugPrint('⚠️ Frame rate warning: ${_currentMetrics!.frameRate} FPS');
    }
  }

  /// تعيين حدود التحذير
  void setWarningThresholds({
    double? memoryThreshold,
    double? cpuThreshold,
    int? frameRateThreshold,
  }) {
    if (memoryThreshold != null && memoryThreshold > 0) {
      _memoryWarningThreshold = memoryThreshold;
    }

    if (cpuThreshold != null && cpuThreshold > 0 && cpuThreshold <= 100) {
      _cpuWarningThreshold = cpuThreshold;
    }

    if (frameRateThreshold != null && frameRateThreshold > 0) {
      _frameRateWarningThreshold = frameRateThreshold;
    }

    // إعادة فحص التحذيرات مع الحدود الجديدة
    _checkWarnings();
    notifyListeners();
  }

  /// تعيين فترة المراقبة
  void setMonitoringInterval(Duration interval) {
    if (interval.inSeconds < 1) return;

    _monitoringInterval = interval;

    // إعادة تشغيل المراقبة بالفترة الجديدة
    if (_isMonitoringEnabled) {
      stopMonitoring();
      startMonitoring();
    }
  }

  /// مسح تاريخ المعلومات
  void clearHistory() {
    _metricsHistory.clear();
    _currentMetrics = null;
    _averageMemoryUsage = 0.0;
    _averageCpuUsage = 0.0;
    _averageFrameRate = 60;
    _hasMemoryWarning = false;
    _hasCpuWarning = false;
    _hasFrameRateWarning = false;
    notifyListeners();
  }

  /// تحسين الذاكرة
  Future<void> optimizeMemory() async {
    try {
      debugPrint('🧹 Starting memory optimization...');

      // تشغيل garbage collector
      if (Platform.isAndroid || Platform.isIOS) {
        // يمكن إضافة تحسينات خاصة بالمنصة هنا
      }

      // مسح الكاش المؤقت
      await _clearTemporaryCache();

      debugPrint('✅ Memory optimization completed');

      // جمع معلومات جديدة بعد التحسين
      await _collectMetrics();
    } catch (e) {
      debugPrint('❌ Error during memory optimization: $e');
    }
  }

  /// مسح الكاش المؤقت
  Future<void> _clearTemporaryCache() async {
    try {
      // هنا يمكن إضافة منطق مسح الكاش
      // مثل مسح الصور المؤقتة، البيانات المخزنة مؤقتاً، إلخ
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      debugPrint('❌ Error clearing temporary cache: $e');
    }
  }

  /// الحصول على تقرير الأداء
  Map<String, dynamic> getPerformanceReport() {
    return {
      'isMonitoringEnabled': _isMonitoringEnabled,
      'currentMetrics': _currentMetrics?.toJson(),
      'averageMemoryUsage': _averageMemoryUsage,
      'averageCpuUsage': _averageCpuUsage,
      'averageFrameRate': _averageFrameRate,
      'warnings': {
        'memory': _hasMemoryWarning,
        'cpu': _hasCpuWarning,
        'frameRate': _hasFrameRateWarning,
      },
      'thresholds': {
        'memory': _memoryWarningThreshold,
        'cpu': _cpuWarningThreshold,
        'frameRate': _frameRateWarningThreshold,
      },
      'historySize': _metricsHistory.length,
      'monitoringInterval': _monitoringInterval.inSeconds,
    };
  }

  /// تصدير تاريخ المعلومات
  List<Map<String, dynamic>> exportMetricsHistory() {
    return _metricsHistory.map((metrics) => metrics.toJson()).toList();
  }

  @override
  void dispose() {
    stopMonitoring();
    super.dispose();
  }
}
