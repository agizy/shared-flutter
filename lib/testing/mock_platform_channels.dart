/// Mock implementations for platform channel testing
///
/// Use these to test code that depends on platform channels without
/// requiring actual native implementations.
library;

import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mocks the thumbnail service platform channel
class MockThumbnailChannel {
  static const MethodChannel _channel = MethodChannel(
    'com.example.shared/thumbnail',
  );

  static void setup() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, _handleMethodCall);
  }

  static void teardown() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  }

  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'generateThumbnail':
        final args = call.arguments as Map<dynamic, dynamic>;
        final width = args['width'] as int;
        final height = args['height'] as int;
        // Return mock thumbnail data
        return Uint8List.fromList(List.filled(width * height ~/ 4, 0xFF));

      case 'generateThumbnailsBatch':
        final args = call.arguments as Map<dynamic, dynamic>;
        final paths = args['imagePaths'] as List<dynamic>;
        return {for (final path in paths) path: Uint8List.fromList([1, 2, 3])};

      case 'getOptimizedThumbnail':
        return Uint8List.fromList([1, 2, 3, 4, 5]);

      case 'clearCache':
        return null;

      case 'getCacheSize':
        return 1024 * 1024; // 1MB

      default:
        throw MissingPluginException('Method ${call.method} not implemented');
    }
  }
}

/// Mocks the shake service platform channel
class MockShakeChannel {
  static const MethodChannel _channel = MethodChannel(
    'com.example.shared/shake',
  );

  static Function? _onShakeCallback;

  static void setup() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, _handleMethodCall);
  }

  static void teardown() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
    _onShakeCallback = null;
  }

  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'startListening':
        return null;

      case 'stopListening':
        return null;

      case 'isAvailable':
        return true;

      case 'simulateShake':
        // Trigger shake event through the channel
        _triggerShakeEvent();
        return null;

      default:
        throw MissingPluginException('Method ${call.method} not implemented');
    }
  }

  static void _triggerShakeEvent() {
    // This would normally be called from native, but for testing
    // we can expose a way to trigger it
    final now = DateTime.now().millisecondsSinceEpoch;
    _channel.invokeMethod('onShake', {
      'timestamp': now,
      'intensity': 20.0,
      'shakeCount': 3,
    });
  }

  /// Simulate a shake event in tests
  static Future<void> simulateShake() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _channel.invokeMethod('onShake', {
      'timestamp': now,
      'intensity': 20.0,
      'shakeCount': 3,
    });
  }
}

/// Mocks the storage service platform channel
class MockStorageChannel {
  static const MethodChannel _channel = MethodChannel(
    'com.example.shared/storage',
  );

  static void setup() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, _handleMethodCall);
  }

  static void teardown() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  }

  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getStorageVolumes':
        return [
          {
            'path': '/storage/emulated/0',
            'name': 'Internal Storage',
            'totalBytes': 128 * 1024 * 1024 * 1024, // 128GB
            'freeBytes': 64 * 1024 * 1024 * 1024,   // 64GB
            'isRemovable': false,
            'isEmulated': false,
          }
        ];

      case 'getAppStorageInfo':
        return {
          'cacheSize': 10 * 1024 * 1024,      // 10MB
          'dataSize': 50 * 1024 * 1024,       // 50MB
          'externalCacheSize': 5 * 1024 * 1024, // 5MB
        };

      case 'scanDirectory':
        final args = call.arguments as Map<dynamic, dynamic>;
        final path = args['path'] as String;
        return [
          {
            'path': '$path/file1.jpg',
            'name': 'file1.jpg',
            'isDirectory': false,
            'size': 1024 * 1024,
            'modifiedDate': DateTime.now().millisecondsSinceEpoch,
            'mimeType': 'image/jpeg',
          },
          {
            'path': '$path/file2.png',
            'name': 'file2.png',
            'isDirectory': false,
            'size': 2 * 1024 * 1024,
            'modifiedDate': DateTime.now().millisecondsSinceEpoch,
            'mimeType': 'image/png',
          },
        ];

      case 'analyzeStorage':
        return {
          'byCategory': {
            'images': 100 * 1024 * 1024,
            'videos': 500 * 1024 * 1024,
            'documents': 50 * 1024 * 1024,
          },
          'byExtension': {
            '.jpg': 80 * 1024 * 1024,
            '.png': 20 * 1024 * 1024,
            '.mp4': 500 * 1024 * 1024,
          },
          'totalFiles': 1000,
          'totalDirectories': 50,
          'largestFilesSize': 1024 * 1024 * 1024,
        };

      case 'findLargeFiles':
        return [
          {
            'path': '/storage/video1.mp4',
            'name': 'video1.mp4',
            'isDirectory': false,
            'size': 500 * 1024 * 1024,
            'modifiedDate': DateTime.now().millisecondsSinceEpoch,
            'mimeType': 'video/mp4',
          },
        ];

      case 'getDirectorySize':
        return 100 * 1024 * 1024; // 100MB

      case 'clearCache':
        return 10 * 1024 * 1024; // Freed 10MB

      default:
        throw MissingPluginException('Method ${call.method} not implemented');
    }
  }
}

/// Sets up all mock platform channels for testing
void setupMockPlatformChannels() {
  MockThumbnailChannel.setup();
  MockShakeChannel.setup();
  MockStorageChannel.setup();
}

/// Tears down all mock platform channels
void teardownMockPlatformChannels() {
  MockThumbnailChannel.teardown();
  MockShakeChannel.teardown();
  MockStorageChannel.teardown();
}

/// Helper extension for testing platform channels
extension PlatformChannelTestHelper on TestWidgetsFlutterBinding {
  /// Setup mock platform channels before test
  void setupMockChannels() => setupMockPlatformChannels();

  /// Teardown mock platform channels after test
  void teardownMockChannels() => teardownMockPlatformChannels();
}
