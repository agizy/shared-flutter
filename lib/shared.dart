library shared;

// ============================================
// GNOME DESIGN SYSTEM
// 80/20 Rule: 80% functionality, 20% decoration
// Inspired by GNOME Libadwaita + Fossify
// ============================================

// Design System - Colors & Theme
export 'design/gnome_theme.dart';

// Design System - Animations
export 'design/gnome_animations.dart';

// Design System - Shapes
export 'design/gnome_shapes.dart';

// ============================================
// GNOME WIDGETS
// ============================================

// Core UI Components
export 'widgets/gnome_app_bar.dart';
export 'widgets/gnome_button.dart';
export 'widgets/gnome_card.dart';
export 'widgets/gnome_empty_state.dart';
// export 'widgets/gnome_icon_button.dart';  // Disabled - GnomeIconButton is in gnome_button.dart
export 'widgets/gnome_list_tile.dart';
export 'widgets/gnome_loading.dart';
export 'widgets/gnome_page_transition.dart';

// ============================================
// MONETIZATION
// ============================================

export 'monetization/ad_service.dart';
export 'monetization/premium_repository.dart';
export 'monetization/paywall_screen.dart';

// ============================================
// LOCALIZATION
// Top 25 GDP countries, 17 languages
// ============================================

export 'localization/app_localizations.dart';
export 'localization/supported_locales.dart';
export 'localization/string_extensions.dart';

// ============================================
// UTILS
// ============================================

export 'utils/debug_flags.dart';

// ============================================
// LEGACY WIDGETS (Deprecated - migrate to GNOME widgets)
// ============================================

export 'widgets/banner_ad_widget.dart';
