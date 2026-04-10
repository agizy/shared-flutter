/// Platform channel service for storage access
///
/// Provides native storage analysis capabilities for file management apps.
library;

import 'package:flutter/foundation.dart';

import 'platform_channel_base.dart';

/// Information about a storage volume
class StorageVolume {
  final String path;
  final String? name;
  final int totalBytes;
  final int freeBytes;
  final bool isRemovable;
  final bool isEmulated;

  const StorageVolume({
    required this.path,
    this.name,
    required this.totalBytes,
    required this.freeBytes,
    required this.isRemovable,
    required this.isEmulated,
  });

  int get usedBytes => totalBytes - freeBytes;
  double get usedPercentage => totalBytes > 0 ? usedBytes / totalBytes : 0;

  factory StorageVolume.fromMap(Map<dynamic, dynamic> map) {
    return StorageVolume(
      path: map['path'] as String,
      name: map['name'] as String?,
      totalBytes: map['totalBytes'] as int,
      freeBytes: map['freeBytes'] as int,
      isRemovable: map['isRemovable'] as bool,
      isEmulated: map['isEmulated'] as bool,
    );
  }
}

/// Information about a file or directory
class FileInfo {
  final String path;
  final String name;
  final bool isDirectory;
  final int size;
  final DateTime modifiedDate;
  final String? mimeType;

  const FileInfo({
    required this.path,
    required this.name,
    required this.isDirectory,
    required this.size,
    required this.modifiedDate,
    this.mimeType,
  });

  factory FileInfo.fromMap(Map<dynamic, dynamic> map) {
    return FileInfo(
      path: map['path'] as String,
      name: map['name'] as String,
      isDirectory: map['isDirectory'] as bool,
      size: map['size'] as int,
      modifiedDate: DateTime.fromMillisecondsSinceEpoch(map['modifiedDate'] as int),
      mimeType: map['mimeType'] as String?,
    );
  }
}

/// Storage analysis result
class StorageAnalysis {
  final Map<String, int> byCategory;
  final Map<String, int> byExtension;
  final int totalFiles;
  final int totalDirectories;
  final int largestFilesSize;

  const StorageAnalysis({
    required this.byCategory,
    required this.byExtension,
    required this.totalFiles,
    required this.totalDirectories,
    required this.largestFilesSize,
  });

  factory StorageAnalysis.fromMap(Map<dynamic, dynamic> map) {
    return StorageAnalysis(
      byCategory: Map<String, int>.from(map['byCategory'] as Map),
      byExtension: Map<String, int>.from(map['byExtension'] as Map),
      totalFiles: map['totalFiles'] as int,
      totalDirectories: map['totalDirectories'] as int,
      largestFilesSize: map['largestFilesSize'] as int,
    );
  }
}

/// Service for storage access via platform channels
class StorageService extends PlatformChannelBase with PlatformAvailabilityMixin {
  static const String _channelName = 'com.example.shared/storage';
  
  StorageService() : super(_channelName);

  /// Get all storage volumes
  Future<List<StorageVolume>> getStorageVolumes() async {
    if (isWeb) {
      return [];
    }

    final result = await invokeMethod<List<dynamic>>('getStorageVolumes');
    if (result == null) {
      return [];
    }

    return result
        .map((e) => StorageVolume.fromMap(e as Map<dynamic, dynamic>))
        .toList();
  }

  /// Get app-specific storage info
  Future<Map<String, int>> getAppStorageInfo() async {
    if (isWeb) {
      return {};
    }

    final result = await invokeMethod<Map<dynamic, dynamic>>('getAppStorageInfo');
    if (result == null) {
      return {};
    }

    return Map<String, int>.from(result);
  }

  /// Scan directory and return file info
  Future<List<FileInfo>> scanDirectory(
    String path, {
    bool recursive = false,
    List<String>? extensions,
  }) async {
    if (isWeb) {
      return [];
    }

    final result = await invokeMethod<List<dynamic>>('scanDirectory', {
      'path': path,
      'recursive': recursive,
      'extensions': extensions,
    });

    if (result == null) {
      return [];
    }

    return result
        .map((e) => FileInfo.fromMap(e as Map<dynamic, dynamic>))
        .toList();
  }

  /// Analyze storage usage by category
  Future<StorageAnalysis> analyzeStorage(String path) async {
    if (isWeb) {
      return const StorageAnalysis(
        byCategory: {},
        byExtension: {},
        totalFiles: 0,
        totalDirectories: 0,
        largestFilesSize: 0,
      );
    }

    final result = await invokeMethod<Map<dynamic, dynamic>>('analyzeStorage', {
      'path': path,
    });

    if (result == null) {
      return const StorageAnalysis(
        byCategory: {},
        byExtension: {},
        totalFiles: 0,
        totalDirectories: 0,
        largestFilesSize: 0,
      );
    }

    return StorageAnalysis.fromMap(result);
  }

  /// Find large files
  Future<List<FileInfo>> findLargeFiles(
    String path, {
    int minSize = 100 * 1024 * 1024, // 100MB default
    int limit = 50,
  }) async {
    if (isWeb) {
      return [];
    }

    final result = await invokeMethod<List<dynamic>>('findLargeFiles', {
      'path': path,
      'minSize': minSize,
      'limit': limit,
    });

    if (result == null) {
      return [];
    }

    return result
        .map((e) => FileInfo.fromMap(e as Map<dynamic, dynamic>))
        .toList();
  }

  /// Clear app cache
  Future<int> clearCache() async {
    if (isWeb) return 0;
    return await invokeMethod<int>('clearCache') ?? 0;
  }

  /// Get directory size
  Future<int> getDirectorySize(String path) async {
    if (isWeb) return 0;
    return await invokeMethod<int>('getDirectorySize', {'path': path}) ?? 0;
  }

  @override
  Future<dynamic> onMethodCall(String method, dynamic arguments) async {
    switch (method) {
      case 'onScanProgress':
        // Notify about scan progress
        if (kDebugMode) {
          print('Storage scan progress: $arguments');
        }
        return null;
      default:
        throw MissingPluginException('Method $method not implemented');
    }
  }
}

/// Singleton instance
final storageService = StorageService();
