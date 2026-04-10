/// Platform channel service for generating image thumbnails
///
/// Provides high-performance native thumbnail generation for gallery apps.
library;

import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import 'platform_channel_base.dart';

/// Service for generating image thumbnails via platform channels
class ThumbnailService extends PlatformChannelBase with PlatformAvailabilityMixin {
  static const String _channelName = 'com.example.shared/thumbnail';
  
  ThumbnailService() : super(_channelName);

  /// Generate a thumbnail from an image file
  ///
  /// [imagePath] - Path to the source image
  /// [width] - Desired thumbnail width
  /// [height] - Desired thumbnail height
  /// [quality] - JPEG quality (0-100), default 85
  ///
  /// Returns the thumbnail as bytes, or null if generation failed
  Future<Uint8List?> generateThumbnail(
    String imagePath, {
    required int width,
    required int height,
    int quality = 85,
  }) async {
    if (isWeb) {
      // Web doesn't support native thumbnails
      return null;
    }

    return invokeMethod<Uint8List>('generateThumbnail', {
      'imagePath': imagePath,
      'width': width,
      'height': height,
      'quality': quality,
    });
  }

  /// Generate multiple thumbnails in batch
  ///
  /// More efficient than generating one at a time
  Future<Map<String, Uint8List?>> generateThumbnailsBatch(
    List<String> imagePaths, {
    required int width,
    required int height,
    int quality = 85,
  }) async {
    if (isWeb || imagePaths.isEmpty) {
      return {};
    }

    final result = await invokeMethod<Map<dynamic, dynamic>>('generateThumbnailsBatch', {
      'imagePaths': imagePaths,
      'width': width,
      'height': height,
      'quality': quality,
    });

    if (result == null) {
      return {};
    }

    return result.map((key, value) => MapEntry(
      key as String,
      value as Uint8List?,
    ));
  }

  /// Get thumbnail with platform-specific optimizations
  ///
  /// On Android: Uses MediaStore for gallery images
  /// On iOS: Uses PHAsset for photos
  Future<Uint8List?> getOptimizedThumbnail(
    String imagePath, {
    required int size,
  }) async {
    if (isWeb) {
      return null;
    }

    return invokeMethod<Uint8List>('getOptimizedThumbnail', {
      'imagePath': imagePath,
      'size': size,
    });
  }

  /// Clear thumbnail cache
  Future<void> clearCache() async {
    if (isWeb) return;
    await invokeMethod<void>('clearCache');
  }

  /// Get cache size in bytes
  Future<int> getCacheSize() async {
    if (isWeb) return 0;
    return await invokeMethod<int>('getCacheSize') ?? 0;
  }

  @override
  Future<dynamic> onMethodCall(String method, dynamic arguments) async {
    // Handle calls from native side if needed
    switch (method) {
      case 'onThumbnailGenerated':
        // Native can notify when background thumbnail is ready
        if (kDebugMode) {
          print('Thumbnail generated: $arguments');
        }
        return null;
      default:
        throw MissingPluginException('Method $method not implemented');
    }
  }
}

/// Singleton instance
final thumbnailService = ThumbnailService();
