# Shared Package

Common code shared across all Flutter apps in this collection.

## 📦 What's Included

### Design System (`lib/design/`)

GNOME Libadwaita-inspired design system:

```dart
// Themes
GnomeTheme.light(accent: GnomeAccent.blue)
GnomeTheme.dark(accent: GnomeAccent.orange)

// Colors
GnomeColors.blue
GnomeColors.green
GnomeColors.orange
// ... 9 accent colors
```

### Widgets (`lib/widgets/`)

Reusable UI components:

```dart
// App bar
GnomeAppBar(
  title: Text('My App'),
  actions: [...],
)

// Card
GnomeCard(
  onTap: () {},
  child: ...,
)

// Button
GnomeButton.suggested(
  onPressed: () {},
  label: 'Confirm',
)

// Loading
GnomeLoadingIndicator()

// Empty states
GnomeEmptyState.search(
  query: 'omelette',
  onClear: () {},
)
```

### Monetization (`lib/monetization/`)

Services for in-app purchases and ads:

```dart
// Ad service
final adService = AdService();
await adService.initialize();
await adService.showRewardedAd(onRewarded: () {});

// Premium repository
final premiumRepo = PremiumRepository();
await premiumRepo.initialize('my_app_premium');
await premiumRepo.purchasePremium();
```

## 🚀 Usage

Add to `pubspec.yaml`:

```yaml
dependencies:
  shared:
    path: ../shared
```

Import in your code:

```dart
import 'package:shared/design/gnome_theme.dart';
import 'package:shared/widgets/gnome_app_bar.dart';
import 'package:shared/monetization/ad_service.dart';
```

## 🎨 Design Tokens

| Token | Value | Usage |
|-------|-------|-------|
| Border Radius (Buttons) | 6px | Buttons, inputs |
| Border Radius (Cards) | 12px | Cards, dialogs |
| Primary Blue | #3584E4 | Default accent |
| Orange | #FF7800 | Alternative accent |

## 📝 License

Private - All rights reserved.
