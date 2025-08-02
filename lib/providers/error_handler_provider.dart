import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// نوع الخطأ
enum ErrorType {
  network,
  storage,
  permission,
  playback,
  database,
  general,
}

/// مستوى الخطأ
enum ErrorSeverity {
  low,
  medium,
  high,
  critical,
}

/// نموذج الخطأ
class AppError {
  final String id;
  final String message;
  final String? details;
  final ErrorType type;
  final ErrorSeverity severity;
  final DateTime timestamp;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? context;

  AppError({
    required this.id,
    required this.message,
    this.details,
    required this.type,
    required this.severity,
    required this.timestamp,
    this.stackTrace,
    this.context,
  });

  /// إنشاء خطأ من استثناء
  factory AppError.fromException(
    Exception exception, {
    ErrorType type = ErrorType.general,
    ErrorSeverity severity = ErrorSeverity.medium,
    Map<String, dynamic>? context,
  }) {
    return AppError(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: exception.toString(),
      type: type,
      severity: severity,
      timestamp: DateTime.now(),
      context: context,
    );
  }

  /// تحويل إلى JSON للتسجيل
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'details': details,
      'type': type.name,
      'severity': severity.name,
      'timestamp': timestamp.toIso8601String(),
      'context': context,
    };
  }
}

/// مزود إدارة الأخطاء والتنبيهات
class ErrorHandlerProvider extends ChangeNotifier {
  final List<AppError> _errors = [];
  final List<String> _notifications = [];
  
  // إعدادات التنبيهات
  bool _showErrorSnackbars = true;
  bool _logErrorsToConsole = kDebugMode;
  int _maxStoredErrors = 50;
  int _maxNotifications = 10;

  // Getters
  List<AppError> get errors => List.unmodifiable(_errors);
  List<String> get notifications => List.unmodifiable(_notifications);
  bool get hasErrors => _errors.isNotEmpty;
  bool get hasNotifications => _notifications.isNotEmpty;
  int get errorCount => _errors.length;
  int get notificationCount => _notifications.length;

  /// إضافة خطأ جديد
  void addError(AppError error) {
    _errors.insert(0, error);
    
    // الحفاظ على الحد الأقصى للأخطاء المحفوظة
    if (_errors.length > _maxStoredErrors) {
      _errors.removeRange(_maxStoredErrors, _errors.length);
    }

    // تسجيل الخطأ في وحدة التحكم إذا كان مفعلاً
    if (_logErrorsToConsole) {
      debugPrint('🚨 Error [${error.type.name}]: ${error.message}');
      if (error.details != null) {
        debugPrint('📝 Details: ${error.details}');
      }
      if (error.context != null) {
        debugPrint('🔍 Context: ${error.context}');
      }
    }

    notifyListeners();
  }

  /// إضافة خطأ من استثناء
  void addErrorFromException(
    Exception exception, {
    ErrorType type = ErrorType.general,
    ErrorSeverity severity = ErrorSeverity.medium,
    String? details,
    Map<String, dynamic>? context,
  }) {
    final error = AppError.fromException(
      exception,
      type: type,
      severity: severity,
      context: context,
    );
    
    if (details != null) {
      final updatedError = AppError(
        id: error.id,
        message: error.message,
        details: details,
        type: error.type,
        severity: error.severity,
        timestamp: error.timestamp,
        stackTrace: error.stackTrace,
        context: error.context,
      );
      addError(updatedError);
    } else {
      addError(error);
    }
  }

  /// إضافة خطأ بسيط
  void addSimpleError(
    String message, {
    ErrorType type = ErrorType.general,
    ErrorSeverity severity = ErrorSeverity.medium,
    String? details,
  }) {
    final error = AppError(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      details: details,
      type: type,
      severity: severity,
      timestamp: DateTime.now(),
    );
    addError(error);
  }

  /// إضافة تنبيه
  void addNotification(String message) {
    _notifications.insert(0, message);
    
    // الحفاظ على الحد الأقصى للتنبيهات
    if (_notifications.length > _maxNotifications) {
      _notifications.removeRange(_maxNotifications, _notifications.length);
    }

    notifyListeners();
  }

  /// مسح خطأ محدد
  void removeError(String errorId) {
    _errors.removeWhere((error) => error.id == errorId);
    notifyListeners();
  }

  /// مسح تنبيه محدد
  void removeNotification(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications.removeAt(index);
      notifyListeners();
    }
  }

  /// مسح جميع الأخطاء
  void clearAllErrors() {
    _errors.clear();
    notifyListeners();
  }

  /// مسح جميع التنبيهات
  void clearAllNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  /// مسح الأخطاء حسب النوع
  void clearErrorsByType(ErrorType type) {
    _errors.removeWhere((error) => error.type == type);
    notifyListeners();
  }

  /// مسح الأخطاء حسب مستوى الخطورة
  void clearErrorsBySeverity(ErrorSeverity severity) {
    _errors.removeWhere((error) => error.severity == severity);
    notifyListeners();
  }

  /// الحصول على الأخطاء حسب النوع
  List<AppError> getErrorsByType(ErrorType type) {
    return _errors.where((error) => error.type == type).toList();
  }

  /// الحصول على الأخطاء حسب مستوى الخطورة
  List<AppError> getErrorsBySeverity(ErrorSeverity severity) {
    return _errors.where((error) => error.severity == severity).toList();
  }

  /// الحصول على الأخطاء الحرجة
  List<AppError> getCriticalErrors() {
    return getErrorsBySeverity(ErrorSeverity.critical);
  }

  /// التحقق من وجود أخطاء حرجة
  bool hasCriticalErrors() {
    return _errors.any((error) => error.severity == ErrorSeverity.critical);
  }

  /// عرض رسالة خطأ في SnackBar
  void showErrorSnackbar(BuildContext context, AppError error) {
    if (!_showErrorSnackbars) return;

    final messenger = ScaffoldMessenger.of(context);
    
    // اختيار لون حسب مستوى الخطورة
    Color backgroundColor;
    IconData icon;
    
    switch (error.severity) {
      case ErrorSeverity.low:
        backgroundColor = Colors.blue;
        icon = Icons.info;
        break;
      case ErrorSeverity.medium:
        backgroundColor = Colors.orange;
        icon = Icons.warning;
        break;
      case ErrorSeverity.high:
        backgroundColor = Colors.red;
        icon = Icons.error;
        break;
      case ErrorSeverity.critical:
        backgroundColor = Colors.red.shade900;
        icon = Icons.dangerous;
        break;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    error.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (error.details != null)
                    Text(
                      error.details!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: Duration(
          seconds: error.severity == ErrorSeverity.critical ? 10 : 4,
        ),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () => messenger.hideCurrentSnackBar(),
        ),
      ),
    );
  }

  /// عرض حوار خطأ
  Future<void> showErrorDialog(BuildContext context, AppError error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: error.severity != ErrorSeverity.critical,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                error.severity == ErrorSeverity.critical
                    ? Icons.dangerous
                    : Icons.error,
                color: error.severity == ErrorSeverity.critical
                    ? Colors.red.shade900
                    : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                error.severity == ErrorSeverity.critical
                    ? 'Critical Error'
                    : 'Error',
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(error.message),
                if (error.details != null) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Details:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(error.details!),
                ],
                if (kDebugMode && error.context != null) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Context:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(error.context.toString()),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
            if (kDebugMode)
              TextButton(
                onPressed: () {
                  // نسخ تفاصيل الخطأ للحافظة
                  Navigator.of(context).pop();
                },
                child: const Text('Copy Details'),
              ),
          ],
        );
      },
    );
  }

  /// تعيين إعدادات التنبيهات
  void updateSettings({
    bool? showErrorSnackbars,
    bool? logErrorsToConsole,
    int? maxStoredErrors,
    int? maxNotifications,
  }) {
    if (showErrorSnackbars != null) {
      _showErrorSnackbars = showErrorSnackbars;
    }
    if (logErrorsToConsole != null) {
      _logErrorsToConsole = logErrorsToConsole;
    }
    if (maxStoredErrors != null && maxStoredErrors > 0) {
      _maxStoredErrors = maxStoredErrors;
      // تطبيق الحد الجديد
      if (_errors.length > _maxStoredErrors) {
        _errors.removeRange(_maxStoredErrors, _errors.length);
      }
    }
    if (maxNotifications != null && maxNotifications > 0) {
      _maxNotifications = maxNotifications;
      // تطبيق الحد الجديد
      if (_notifications.length > _maxNotifications) {
        _notifications.removeRange(_maxNotifications, _notifications.length);
      }
    }
    notifyListeners();
  }

  /// تصدير الأخطاء كـ JSON
  List<Map<String, dynamic>> exportErrors() {
    return _errors.map((error) => error.toJson()).toList();
  }

  /// إحصائيات الأخطاء
  Map<String, int> getErrorStatistics() {
    final stats = <String, int>{};
    
    for (final type in ErrorType.values) {
      stats['${type.name}_count'] = getErrorsByType(type).length;
    }
    
    for (final severity in ErrorSeverity.values) {
      stats['${severity.name}_count'] = getErrorsBySeverity(severity).length;
    }
    
    return stats;
  }
}