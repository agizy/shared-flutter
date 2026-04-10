/// Platform channel service for shake detection
///
/// Provides custom shake detection algorithm via native code for better
/// performance and battery efficiency than sensors_plus plugin.
library;

import 'dart:async';
import 'package:flutter/foundation.dart';

import 'platform_channel_base.dart';

/// Configuration for shake detection
class ShakeConfig {
  /// Minimum acceleration to consider as shake (in m/s²)
  final double threshold;

  /// Minimum time between shakes (in milliseconds)
  final int debounceMs;

  /// Number of acceleration peaks required for a shake
  final int minShakeCount;

  const ShakeConfig({
    this.threshold = 15.0,      // ~1.5g
    this.debounceMs = 1000,     // 1 second between shakes
    this.minShakeCount = 3,     // 3 peaks = 1 shake
  });

  Map<String, dynamic> toMap() => {
    'threshold': threshold,
    'debounceMs': debounceMs,
    'minShakeCount': minShakeCount,
  };
}

/// Callback type for shake events
typedef ShakeCallback = void Function(ShakeEvent event);

/// Shake event data
class ShakeEvent {
  final DateTime timestamp;
  final double intensity;
  final int shakeCount;

  const ShakeEvent({
    required this.timestamp,
    required this.intensity,
    required this.shakeCount,
  });

  factory ShakeEvent.fromMap(Map<dynamic, dynamic> map) {
    return ShakeEvent(
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      intensity: map['intensity'] as double,
      shakeCount: map['shakeCount'] as int,
    );
  }
}

/// Service for shake detection via platform channels
class ShakeService extends PlatformChannelBase with PlatformAvailabilityMixin {
  static const String _channelName = 'com.example.shared/shake';
  
  ShakeService() : super(_channelName);

  final List<ShakeCallback> _listeners = [];
  bool _isListening = false;

  /// Whether shake detection is currently active
  bool get isListening => _isListening;

  /// Add a listener for shake events
  void addListener(ShakeCallback callback) {
    _listeners.add(callback);
  }

  /// Remove a listener
  void removeListener(ShakeCallback callback) {
    _listeners.remove(callback);
  }

  /// Start listening for shake events
  Future<void> startListening([ShakeConfig config = const ShakeConfig()]) async {
    if (isWeb) {
      throw UnsupportedError('Shake detection not supported on web');
    }

    if (_isListening) {
      return;
    }

    await invokeMethod<void>('startListening', config.toMap());
    _isListening = true;

    if (kDebugMode) {
      print('Shake detection started with threshold: ${config.threshold}');
    }
  }

  /// Stop listening for shake events
  Future<void> stopListening() async {
    if (!_isListening) {
      return;
    }

    await invokeMethod<void>('stopListening');
    _isListening = false;

    if (kDebugMode) {
      print('Shake detection stopped');
    }
  }

  /// Check if shake detection is available on this device
  Future<bool> isAvailable() async {
    if (isWeb) return false;
    return await invokeMethod<bool>('isAvailable') ?? false;
  }

  /// Simulate a shake (for testing)
  @visibleForTesting
  Future<void> simulateShake() async {
    await invokeMethod<void>('simulateShake');
  }

  @override
  Future<dynamic> onMethodCall(String method, dynamic arguments) async {
    switch (method) {
      case 'onShake':
        final event = ShakeEvent.fromMap(arguments as Map<dynamic, dynamic>);
        _notifyListeners(event);
        return null;
      case 'onError':
        if (kDebugMode) {
          print('Shake service error: $arguments');
        }
        return null;
      default:
        throw MissingPluginException('Method $method not implemented');
    }
  }

  void _notifyListeners(ShakeEvent event) {
    for (final listener in _listeners) {
      try {
        listener(event);
      } catch (e) {
        if (kDebugMode) {
          print('Error in shake listener: $e');
        }
      }
    }
  }

  /// Stream of shake events
  Stream<ShakeEvent> get onShake {
    late StreamController<ShakeEvent> controller;
    ShakeCallback? callback;

    controller = StreamController<ShakeEvent>(
      onListen: () async {
        callback = (event) => controller.add(event);
        addListener(callback!);
        await startListening();
      },
      onCancel: () async {
        if (callback != null) {
          removeListener(callback!);
        }
        await stopListening();
      },
    );

    return controller.stream;
  }
}

/// Singleton instance
final shakeService = ShakeService();
