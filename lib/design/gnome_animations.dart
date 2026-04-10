import 'package:flutter/material.dart';

/// GNOME-inspired animation system
/// Based on Libadwaita spring physics and Material Design 3 timing
/// 
/// 80/20 Rule: Animations should be purposeful, not decorative
/// - Use for: feedback, transitions, state changes
/// - Avoid: unnecessary flourishes, long durations

class GnomeAnimations {
  // Private constructor to prevent instantiation
  GnomeAnimations._();

  // ===========================================================================
  // DURATIONS
  // ===========================================================================
  
  /// Micro-interactions: button presses, toggles, icon changes
  /// Use for immediate feedback that an element was tapped
  static const Duration micro = Duration(milliseconds: 100);
  
  /// Short transitions: small UI reveals, color changes
  /// Use for internal state changes within a screen
  static const Duration short = Duration(milliseconds: 200);
  
  /// Medium transitions: page transitions, modal appearances
  /// Most common duration for screen-to-screen navigation
  static const Duration medium = Duration(milliseconds: 300);
  
  /// Long transitions: complex animations, dismissals
  /// Use sparingly for emphasis
  static const Duration long = Duration(milliseconds: 400);
  
  // ===========================================================================
  // CURVES (GNOME Spring-Physics Inspired)
  // ===========================================================================
  
  /// Standard ease out: elements entering the screen
  /// Decelerates towards the end - feels natural and responsive
  static const Curve easeOut = Curves.easeOutCubic;
  
  /// Standard ease in: elements exiting the screen
  /// Accelerates at the start - quick departure
  static const Curve easeIn = Curves.easeInCubic;
  
  /// Symmetric ease: elements changing in place
  /// Balanced acceleration and deceleration
  static const Curve easeInOut = Curves.easeInOutCubic;
  
  /// Spring/decelerate: natural settling motion
  /// Mimics physical objects - best for scaling/positioning
  static const Curve spring = Curves.decelerate;
  
  /// Linear: continuous animations (progress indicators)
  /// Constant speed throughout
  static const Curve linear = Curves.linear;
  
  /// Emphasized decelerate: Material 3 style entrance
  /// Slight anticipation before movement
  static const Curve emphasizedDecelerate = Cubic(0.05, 0.7, 0.1, 1.0);
  
  /// Emphasized accelerate: Material 3 style exit
  /// Quick departure with slight overshoot feel
  static const Curve emphasizedAccelerate = Cubic(0.3, 0.0, 0.8, 0.15);
  
  // ===========================================================================
  // PAGE TRANSITIONS
  // ===========================================================================
  
  /// Fade + Scale transition (GNOME style)
  /// Elements fade in while scaling from 0.95 to 1.0
  /// Duration: 250ms enter, 200ms exit
  static Widget fadeScale(
    Animation<double> animation,
    Widget child, {
    bool isEntering = true,
  }) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: isEntering ? easeOut : easeIn,
      reverseCurve: isEntering ? easeIn : easeOut,
    );
    
    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: Tween<double>(
          begin: isEntering ? 0.95 : 1.0,
          end: isEntering ? 1.0 : 0.95,
        ).animate(curved),
        child: child,
      ),
    );
  }
  
  /// Slide + Fade transition (horizontal)
  /// Elements slide in from the right while fading
  /// Use for drill-down navigation
  static Widget slideFadeHorizontal(
    Animation<double> animation,
    Widget child, {
    bool isEntering = true,
  }) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: isEntering ? easeOut : easeIn,
    );
    
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: isEntering ? const Offset(0.1, 0) : Offset.zero,
          end: isEntering ? Offset.zero : const Offset(-0.1, 0),
        ).animate(curved),
        child: child,
      ),
    );
  }
  
  /// Slide + Fade transition (vertical)
  /// Elements slide in from the bottom while fading
  /// Use for modals and sheets
  static Widget slideFadeVertical(
    Animation<double> animation,
    Widget child, {
    bool isEntering = true,
  }) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: isEntering ? emphasizedDecelerate : emphasizedAccelerate,
    );
    
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: isEntering ? const Offset(0, 0.2) : Offset.zero,
          end: isEntering ? Offset.zero : const Offset(0, 0.1),
        ).animate(curved),
        child: child,
      ),
    );
  }
  
  /// Shared axis transition (Material 3 style)
  /// Z-axis movement - forward/backward depth
  /// Use for sibling navigation (tabs, steps)
  static Widget sharedAxis(
    Animation<double> animation,
    Widget child, {
    bool isEntering = true,
    SharedAxisDirection direction = SharedAxisDirection.horizontal,
  }) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: isEntering ? emphasizedDecelerate : emphasizedAccelerate,
    );
    
    switch (direction) {
      case SharedAxisDirection.horizontal:
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: isEntering ? const Offset(0.05, 0) : Offset.zero,
              end: isEntering ? Offset.zero : const Offset(-0.05, 0),
            ).animate(curved),
            child: child,
          ),
        );
      case SharedAxisDirection.vertical:
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: isEntering ? const Offset(0, 0.03) : Offset.zero,
              end: isEntering ? Offset.zero : const Offset(0, -0.03),
            ).animate(curved),
            child: child,
          ),
        );
    }
  }
  
  // ===========================================================================
  // MICRO-INTERACTIONS
  // ===========================================================================
  
  /// Button press animation
  /// Subtle scale down on press (0.98x)
  static Widget buttonPress(
    Animation<double> animation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 0.98).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
      ),
      child: child,
    );
  }
  
  /// List item selection animation
  /// Subtle scale pulse on selection
  static Widget listSelection(
    Animation<double> animation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.02), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0), weight: 50),
      ]).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
      ),
      child: child,
    );
  }
  
  /// Fade in animation for content loading
  /// Opacity 0 → 1
  static Widget fadeIn(
    Animation<double> animation,
    Widget child, {
    Duration delay = Duration.zero,
  }) {
    final delayed = CurvedAnimation(
      parent: animation,
      curve: Interval(
        delay.inMilliseconds / medium.inMilliseconds,
        1.0,
        curve: easeOut,
      ),
    );
    
    return FadeTransition(
      opacity: delayed,
      child: child,
    );
  }
  
  /// Staggered list animation
  /// Children animate in sequence with slight delay
  static Widget staggeredListItem(
    Animation<double> animation,
    Widget child, {
    required int index,
    double staggerDelay = 0.05,
  }) {
    final interval = Interval(
      index * staggerDelay,
      (index * staggerDelay) + 0.4,
      curve: easeOut,
    );
    
    final curved = CurvedAnimation(
      parent: animation,
      curve: interval,
    );
    
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
  
  // ===========================================================================
  // UTILITY METHODS
  // ===========================================================================
  
  /// Create a standard page route with GNOME transitions
  static PageRoute<T> pageRoute<T>({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      transitionDuration: medium,
      reverseTransitionDuration: short,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return fadeScale(animation, child);
      },
    );
  }
  
  /// Create a modal route with bottom-up animation
  static PageRoute<T> modalRoute<T>({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      opaque: false,
      barrierColor: Colors.black54,
      transitionDuration: medium,
      reverseTransitionDuration: short,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return slideFadeVertical(animation, child);
      },
    );
  }
}

/// Direction for shared axis transitions
enum SharedAxisDirection {
  horizontal,
  vertical,
}

/// Extension for easy animation controller creation
extension AnimationControllerX on AnimationController {
  /// Animate to target with GNOME standard curve
  Future<void> animateToGnome(double target) {
    return animateTo(
      target,
      duration: GnomeAnimations.short,
      curve: GnomeAnimations.easeOut,
    );
  }
  
  /// Quick micro-animation (button press, etc.)
  Future<void> microAnimate(double target) {
    return animateTo(
      target,
      duration: GnomeAnimations.micro,
      curve: GnomeAnimations.easeInOut,
    );
  }
}

/// Mixin for widgets that need animation controllers
/// Provides automatic disposal
 mixin GnomeAnimationMixin<T extends StatefulWidget> on State<T> {
  final List<AnimationController> _controllers = [];
  
  AnimationController createController({
    Duration duration = GnomeAnimations.short,
  }) {
    final controller = AnimationController(
      vsync: this as TickerProvider,
      duration: duration,
    );
    _controllers.add(controller);
    return controller;
  }
  
  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
