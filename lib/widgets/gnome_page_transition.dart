import 'package:flutter/material.dart';
import '../design/gnome_animations.dart';

/// GNOME-style page transitions
/// 
/// 80/20 Rule: Transitions should feel natural and responsive
/// - Fade + slight scale for most transitions
/// - Quick durations (200-300ms)
/// - Ease-out for entering, ease-in for exiting
/// 
/// Use for: page navigation, modal presentations

/// Fade + scale transition (default GNOME style)
class GnomeFadeScaleTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const GnomeFadeScaleTransition({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GnomeAnimations.fadeScale(animation, child);
  }
}

/// Shared axis transition (for sibling navigation)
class GnomeSharedAxisTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  final SharedAxisDirection direction;

  const GnomeSharedAxisTransition({
    super.key,
    required this.animation,
    required this.child,
    this.direction = SharedAxisDirection.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return GnomeAnimations.sharedAxis(
      animation,
      child,
      direction: direction,
    );
  }
}

/// Slide transition (for modal presentations)
class GnomeSlideTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  final bool fromBottom;

  const GnomeSlideTransition({
    super.key,
    required this.animation,
    required this.child,
    this.fromBottom = true,
  });

  @override
  Widget build(BuildContext context) {
    if (fromBottom) {
      return GnomeAnimations.slideFadeVertical(animation, child);
    }
    return GnomeAnimations.slideFadeHorizontal(animation, child);
  }
}

/// Page route with GNOME transitions
class GnomePageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;
  final bool fullscreenDialog;
  final GnomeTransitionType transitionType;

  GnomePageRoute({
    required this.builder,
    this.fullscreenDialog = false,
    this.transitionType = GnomeTransitionType.fadeScale,
    RouteSettings? settings,
  }) : super(
    settings: settings,
    fullscreenDialog: fullscreenDialog,
    transitionDuration: GnomeAnimations.medium,
    reverseTransitionDuration: GnomeAnimations.short,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (transitionType) {
        case GnomeTransitionType.fadeScale:
          return GnomeAnimations.fadeScale(animation, child);
        case GnomeTransitionType.sharedAxis:
          return GnomeAnimations.sharedAxis(animation, child);
        case GnomeTransitionType.slideHorizontal:
          return GnomeAnimations.slideFadeHorizontal(animation, child);
        case GnomeTransitionType.slideVertical:
          return GnomeAnimations.slideFadeVertical(animation, child);
      }
    },
  );
}

/// Modal route with bottom-up animation
class GnomeModalRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  GnomeModalRoute({
    required this.builder,
    RouteSettings? settings,
  }) : super(
    settings: settings,
    opaque: false,
    barrierColor: Colors.black54,
    barrierDismissible: true,
    transitionDuration: GnomeAnimations.medium,
    reverseTransitionDuration: GnomeAnimations.short,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return GnomeAnimations.slideFadeVertical(animation, child);
    },
  );
}

/// Transition types
enum GnomeTransitionType {
  fadeScale,
  sharedAxis,
  slideHorizontal,
  slideVertical,
}

/// Page transitions theme for MaterialApp
class GnomePageTransitionsTheme extends PageTransitionsTheme {
  GnomePageTransitionsTheme() : super(
    builders: {
      TargetPlatform.android: _GnomePageTransitionBuilder(),
      TargetPlatform.iOS: _GnomePageTransitionBuilder(),
      TargetPlatform.linux: _GnomePageTransitionBuilder(),
      TargetPlatform.macOS: _GnomePageTransitionBuilder(),
      TargetPlatform.windows: _GnomePageTransitionBuilder(),
    },
  );
}

class _GnomePageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return GnomeAnimations.fadeScale(animation, child);
  }
}

/// Extension for easy navigation with GNOME transitions
extension GnomeNavigation on BuildContext {
  /// Push with GNOME fade-scale transition
  Future<T?> pushGnome<T>(
    Widget page, {
    GnomeTransitionType transition = GnomeTransitionType.fadeScale,
  }) {
    return Navigator.push<T>(
      this,
      GnomePageRoute<T>(
        builder: (_) => page,
        transitionType: transition,
      ),
    );
  }

  /// Push modal with bottom-up transition
  Future<T?> pushGnomeModal<T>(Widget page) {
    return Navigator.push<T>(
      this,
      GnomeModalRoute<T>(builder: (_) => page),
    );
  }

  /// Replace with GNOME transition
  Future<T?> pushReplacementGnome<T>(
    Widget page, {
    GnomeTransitionType transition = GnomeTransitionType.fadeScale,
  }) {
    return Navigator.pushReplacement<T, dynamic>(
      this,
      GnomePageRoute<T>(
        builder: (_) => page,
        transitionType: transition,
      ),
    );
  }
}
