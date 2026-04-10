/// Base classes and utilities for platform channel communication
///
/// Provides a standardized way to communicate between Flutter and native code
/// across all apps in the project.
library;

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Exception thrown when platform channel communication fails
class PlatformChannelException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const PlatformChannelException(this.message, {this.code, this.details});

  @override
  String toString() => 'PlatformChannelException: $message (code: $code)';
}

/// Base class for platform channel handlers
///
/// Provides consistent error handling and method call structure
abstract class PlatformChannelBase {
  final MethodChannel _channel;
  final String name;

  PlatformChannelBase(this.name) : _channel = MethodChannel(name) {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  /// The method channel for communication
  MethodChannel get channel => _channel;

  /// Handle incoming method calls from native code
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    try {
      return await onMethodCall(call.method, call.arguments);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Platform channel error in $name: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }

  /// Override this to handle method calls from native code
  Future<dynamic> onMethodCall(String method, dynamic arguments);

  /// Invoke a method on the native side
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) async {
    try {
      return await _channel.invokeMethod<T>(method, arguments);
    } on PlatformException catch (e) {
      throw PlatformChannelException(
        e.message ?? 'Unknown platform error',
        code: e.code,
        details: e.details,
      );
    } catch (e) {
      throw PlatformChannelException('Failed to invoke $method: $e');
    }
  }

  /// Invoke a method with a map of arguments
  Future<T?> invokeMapMethod<T>(String method, Map<String, dynamic> arguments) {
    return invokeMethod<T>(method, arguments);
  }
}

/// Mixin for platform-specific availability checks
mixin PlatformAvailabilityMixin {
  bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;
  bool get isMobile => isAndroid || isIOS;
  bool get isWeb => kIsWeb;
}

/// Result wrapper for platform channel operations
class PlatformResult<T> {
  final T? data;
  final PlatformChannelException? error;
  final bool isSuccess;

  const PlatformResult._(this.data, this.error, this.isSuccess);

  factory PlatformResult.success(T data) =>
      PlatformResult._(data, null, true);

  factory PlatformResult.failure(String message, {String? code, dynamic details}) =>
      PlatformResult._(null, PlatformChannelException(message, code: code, details: details), false);

  factory PlatformResult.fromException(PlatformChannelException e) =>
      PlatformResult._(null, e, false);

  /// Execute a function and wrap the result
  static Future<PlatformResult<T>> run<T>(Future<T> Function() operation) async {
    try {
      final result = await operation();
      return PlatformResult.success(result);
    } on PlatformChannelException catch (e) {
      return PlatformResult.fromException(e);
    } catch (e) {
      return PlatformResult.failure(e.toString());
    }
  }

  /// Get the data or throw if error
  T getOrThrow() {
    if (!isSuccess || error != null) {
      throw error ?? PlatformChannelException('Unknown error');
    }
    return data as T;
  }

  /// Get the data or return a default value
  T getOrDefault(T defaultValue) => data ?? defaultValue;

  /// Map the result to another type
  PlatformResult<R> map<R>(R Function(T) transform) {
    if (!isSuccess || data == null) {
      return PlatformResult._(null, error, false);
    }
    return PlatformResult.success(transform(data as T));
  }
}

/// Utility extension for MethodChannel
extension MethodChannelX on MethodChannel {
  /// Invoke method with better error messages
  Future<T?> invoke<T>(String method, [dynamic arguments]) async {
    try {
      return await invokeMethod<T>(method, arguments);
    } on MissingPluginException {
      throw PlatformChannelException(
        'Platform implementation not found for $method. '
        'Ensure native code is properly implemented.',
        code: 'MISSING_PLUGIN',
      );
    } on PlatformException catch (e) {
      throw PlatformChannelException(
        e.message ?? 'Platform error: $method',
        code: e.code,
        details: e.details,
      );
    }
  }
}
