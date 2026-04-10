# Shared Package API Documentation

This package provides shared functionality for all Flutter apps in the project.

## Modules

### Design System

GNOME Libadwaita-inspired design system for Flutter apps.

- **GnomeTheme** - Light and dark themes with accent colors
- **GnomeColors** - Color palette and semantic colors
- **GnomeAnimations** - Standardized animation curves and durations
- **GnomeButton, GnomeCard, GnomeTextField** - Widget components

```dart
import 'package:shared/design.dart';

// Apply theme
MaterialApp(
  theme: GnomeTheme.light(accent: GnomeAccent.blue),
  darkTheme: GnomeTheme.dark(accent: GnomeAccent.blue),
);
```

### Monetization

Services for ads and premium features.

- **AdService** - Platform-agnostic ad management
- **PremiumRepository** - In-app purchase handling
- **PaywallScreen** - Premium upgrade UI

```dart
import 'package:shared/monetization.dart';

// Initialize services
final adService = AdService();
await adService.initialize();
```

### Platform Channels

High-performance native functionality.

- **ThumbnailService** - Image thumbnail generation
- **ShakeService** - Shake detection
- **StorageService** - Storage analysis

```dart
import 'package:shared/platform.dart';

// Generate thumbnail
final thumb = await thumbnailService.generateThumbnail(
  imagePath,
  width: 200,
  height: 200,
);
```

### Testing Utilities

Helpers for writing tests.

- **MockAdService, MockPremiumRepository** - Mock services
- **makeTestable, makeTestableWithBlocs** - Widget test helpers
- **Mock platform channels** - For testing platform code

```dart
import 'package:shared/testing.dart';

// Setup mocks
setUp(() {
  setupMockPlatformChannels();
});
```

## Getting Started

Add to your `pubspec.yaml`:

```yaml
dependencies:
  shared:
    path: ../shared
```

## Additional Information

For more information, see the project documentation.
