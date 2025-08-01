import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorHandler {
  static void showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onRetry,
    String? retryText,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          if (onRetry != null)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: Text(retryText ?? 'Retry'),
            ),
        ],
      ),
    );
  }

  static void showErrorSnackBar(
    BuildContext context, {
    required String message,
    VoidCallback? onRetry,
    String? retryText,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        action: onRetry != null
            ? SnackBarAction(
                label: retryText ?? 'Retry',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  static String getErrorMessage(dynamic error) {
    if (error is PlatformException) {
      switch (error.code) {
        case 'PERMISSION_DENIED':
          return 'Permission denied. Please grant the necessary permissions.';
        case 'INVALID_ARGUMENT':
          return 'Invalid argument provided.';
        case 'UNAVAILABLE':
          return 'Service unavailable. Please try again later.';
        case 'NOT_FOUND':
          return 'Resource not found.';
        case 'ALREADY_EXISTS':
          return 'Resource already exists.';
        case 'RESOURCE_EXHAUSTED':
          return 'Resource exhausted. Please try again later.';
        case 'FAILED_PRECONDITION':
          return 'Failed precondition. Please check your input.';
        case 'ABORTED':
          return 'Operation aborted. Please try again.';
        case 'OUT_OF_RANGE':
          return 'Out of range. Please check your input.';
        case 'UNIMPLEMENTED':
          return 'Feature not implemented.';
        case 'INTERNAL':
          return 'Internal error occurred. Please try again.';
        case 'DATA_LOSS':
          return 'Data loss detected. Please check your data.';
        case 'UNAUTHENTICATED':
          return 'Authentication required.';
        default:
          return error.message ?? 'An unknown error occurred.';
      }
    }

    if (error is FormatException) {
      return 'Invalid data format. Please check your input.';
    }

    if (error is TypeError) {
      return 'Type error occurred. Please try again.';
    }

    if (error is ArgumentError) {
      return 'Invalid argument provided.';
    }

    if (error is StateError) {
      return 'Invalid state. Please try again.';
    }

    if (error is UnsupportedError) {
      return 'Operation not supported.';
    }

    return error.toString().isNotEmpty
        ? error.toString()
        : 'An unexpected error occurred.';
  }

  static void logError(dynamic error, StackTrace? stackTrace) {
    debugPrint('Error: $error');
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
  }
}

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, String error)? errorBuilder;
  final void Function(dynamic error, StackTrace? stackTrace)? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  String? _error;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(context, _error!) ??
          _buildDefaultErrorWidget();
    }

    return ErrorHandlerWidget(
      onError: (error, stackTrace) {
        setState(() {
          _error = ErrorHandler.getErrorMessage(error);
        });
        widget.onError?.call(error, stackTrace);
        ErrorHandler.logError(error, stackTrace);
      },
      child: widget.child,
    );
  }

  Widget _buildDefaultErrorWidget() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _error ?? 'An unexpected error occurred',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorHandlerWidget extends StatefulWidget {
  final Widget child;
  final void Function(dynamic error, StackTrace? stackTrace) onError;

  const ErrorHandlerWidget({
    super.key,
    required this.child,
    required this.onError,
  });

  @override
  State<ErrorHandlerWidget> createState() => _ErrorHandlerWidgetState();
}

class _ErrorHandlerWidgetState extends State<ErrorHandlerWidget> {
  @override
  void initState() {
    super.initState();
    FlutterError.onError = (FlutterErrorDetails details) {
      widget.onError(details.exception, details.stack);
    };
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// Custom exception classes
class MediaPlayerException implements Exception {
  final String message;
  final String? code;
  final dynamic cause;

  const MediaPlayerException(
    this.message, {
    this.code,
    this.cause,
  });

  @override
  String toString() => 'MediaPlayerException: $message';
}

class NetworkException extends MediaPlayerException {
  const NetworkException(super.message) : super(code: 'NETWORK_ERROR');
}

class FileNotFoundException extends MediaPlayerException {
  const FileNotFoundException(super.message) : super(code: 'FILE_NOT_FOUND');
}

class PermissionDeniedException extends MediaPlayerException {
  const PermissionDeniedException(super.message) : super(code: 'PERMISSION_DENIED');
}

class InvalidFormatException extends MediaPlayerException {
  const InvalidFormatException(super.message) : super(code: 'INVALID_FORMAT');
}

// Retry mechanism
class RetryHandler {
  static Future<T> retry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    bool Function(dynamic error)? retryIf,
  }) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (error) {
        attempts++;
        
        if (attempts >= maxRetries || (retryIf != null && !retryIf(error))) {
          rethrow;
        }
        
        await Future.delayed(delay * attempts);
      }
    }
    
    throw StateError('Retry handler reached impossible state');
  }
}

// Loading state wrapper
class LoadingWrapper extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Widget? loadingWidget;
  final String? loadingText;

  const LoadingWrapper({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingWidget,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ?? _buildDefaultLoadingWidget(context);
    }
    return child;
  }

  Widget _buildDefaultLoadingWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (loadingText != null) ...[
            const SizedBox(height: 16),
            Text(
              loadingText!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

// Empty state widget
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
