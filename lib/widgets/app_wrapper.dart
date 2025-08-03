import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../providers/error_handler_provider.dart';
import '../providers/performance_provider.dart';

/// ويدجت تغليف التطبيق الرئيسي
/// يدير تهيئة المزودات والحالة العامة للتطبيق
class AppWrapper extends StatefulWidget {
  final Widget child;
  
  const AppWrapper({
    super.key,
    required this.child,
  });

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> with WidgetsBindingObserver {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// تهيئة التطبيق والمزودات
  Future<void> _initializeApp() async {
    try {
      final appStateProvider = context.read<AppStateProvider>();
      final errorHandlerProvider = context.read<ErrorHandlerProvider>();
      final performanceProvider = context.read<PerformanceProvider>();

      // تهيئة مزود الحالة العامة
      await appStateProvider.initialize();

      // بدء مراقبة الأداء في وضع التطوير
      if (performanceProvider.isMonitoringEnabled) {
        performanceProvider.startMonitoring();
      }

      // إعداد معالج الأخطاء العام
      FlutterError.onError = (FlutterErrorDetails details) {
        errorHandlerProvider.addSimpleError(
          details.exception.toString(),
          type: ErrorType.general,
          severity: ErrorSeverity.high,
          details: details.stack?.toString(),
        );
      };

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      // في حالة فشل التهيئة، عرض الخطأ
      final errorHandlerProvider = context.read<ErrorHandlerProvider>();
      errorHandlerProvider.addSimpleError(
        'Failed to initialize app: $e',
        type: ErrorType.general,
        severity: ErrorSeverity.critical,
      );
      
      setState(() {
        _isInitialized = true; // السماح بعرض التطبيق حتى مع الأخطاء
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    final performanceProvider = context.read<PerformanceProvider>();
    
    switch (state) {
      case AppLifecycleState.resumed:
        // التطبيق أصبح نشطاً - بدء مراقبة الأداء
        if (performanceProvider.isMonitoringEnabled) {
          performanceProvider.startMonitoring();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // التطبيق في الخلفية - إيقاف مراقبة الأداء لتوفير البطارية
        performanceProvider.stopMonitoring();
        break;
      case AppLifecycleState.detached:
        // التطبيق يتم إغلاقه
        performanceProvider.stopMonitoring();
        break;
      case AppLifecycleState.hidden:
        // التطبيق مخفي
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const _LoadingScreen();
    }

    return Consumer3<AppStateProvider, ErrorHandlerProvider, PerformanceProvider>(
      builder: (context, appState, errorHandler, performance, child) {
        return Stack(
          children: [
            // التطبيق الرئيسي
            widget.child,
            
            // عرض شاشة التحميل إذا كان التطبيق في حالة تحميل
            if (appState.isLoading)
              _LoadingOverlay(message: appState.loadingMessage),
            
            // عرض تحذيرات الأداء في وضع التطوير
            if (performance.hasAnyWarning)
              const _PerformanceWarningIndicator(),
            
            // عرض مؤشر الأخطاء الحرجة
            if (errorHandler.hasCriticalErrors())
              const _CriticalErrorIndicator(),
          ],
        );
      },
    );
  }
}

/// شاشة التحميل الأولية
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF6B73FF),
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
              SizedBox(height: 16),
              Text(
                'Initializing App...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// طبقة تحميل شفافة
class _LoadingOverlay extends StatelessWidget {
  final String message;
  
  const _LoadingOverlay({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// مؤشر تحذيرات الأداء
class _PerformanceWarningIndicator extends StatelessWidget {
  const _PerformanceWarningIndicator();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      right: 10,
      child: Consumer<PerformanceProvider>(
        builder: (context, performance, child) {
          return GestureDetector(
            onTap: () => _showPerformanceDialog(context, performance),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Performance',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPerformanceDialog(BuildContext context, PerformanceProvider performance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Performance Warnings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (performance.hasMemoryWarning)
              Text('⚠️ High memory usage: ${performance.currentMetrics?.memoryUsage.toStringAsFixed(1)} MB'),
            if (performance.hasCpuWarning)
              Text('⚠️ High CPU usage: ${performance.currentMetrics?.cpuUsage.toStringAsFixed(1)}%'),
            if (performance.hasFrameRateWarning)
              Text('⚠️ Low frame rate: ${performance.currentMetrics?.frameRate} FPS'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              performance.optimizeMemory();
              Navigator.of(context).pop();
            },
            child: const Text('Optimize'),
          ),
        ],
      ),
    );
  }
}

/// مؤشر الأخطاء الحرجة
class _CriticalErrorIndicator extends StatelessWidget {
  const _CriticalErrorIndicator();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 10,
      child: Consumer<ErrorHandlerProvider>(
        builder: (context, errorHandler, child) {
          final criticalErrors = errorHandler.getCriticalErrors();
          
          return GestureDetector(
            onTap: () => _showCriticalErrorsDialog(context, criticalErrors),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.dangerous,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${criticalErrors.length} Critical',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCriticalErrorsDialog(BuildContext context, List<AppError> errors) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.dangerous, color: Colors.red),
            SizedBox(width: 8),
            Text('Critical Errors'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: errors.length,
            itemBuilder: (context, index) {
              final error = errors[index];
              return Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        error.message,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (error.details != null)
                        Text(
                          error.details!,
                          style: const TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<ErrorHandlerProvider>().clearErrorsBySeverity(ErrorSeverity.critical);
              Navigator.of(context).pop();
            },
            child: const Text('Clear All'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}