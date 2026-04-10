/// Platform channel services for native functionality
///
/// Provides platform-specific implementations for:
/// - Thumbnail generation
/// - Shake detection
/// - Storage access
///
/// Usage:
/// ```dart
/// import 'package:shared/platform.dart';
///
/// // Generate thumbnail
/// final thumb = await thumbnailService.generateThumbnail(
///   imagePath,
///   width: 200,
///   height: 200,
/// );
///
/// // Shake detection
/// shakeService.addListener((event) {
///   print('Shake detected!');
/// });
/// await shakeService.startListening();
///
/// // Storage analysis
/// final volumes = await storageService.getStorageVolumes();
/// ```
library;

export 'platform/platform_channel_base.dart';
export 'platform/thumbnail_service.dart';
export 'platform/shake_service.dart';
export 'platform/storage_service.dart';
