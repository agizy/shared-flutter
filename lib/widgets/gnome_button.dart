import 'package:flutter/material.dart';
import '../design/gnome_animations.dart';
import '../design/gnome_shapes.dart';
import '../design/gnome_theme.dart';

/// GNOME-style button widget
/// 
/// 80/20 Rule: Buttons should be immediately recognizable and actionable
/// - Clear visual hierarchy (suggested > default > flat)
/// - Subtle feedback on interaction
/// - Consistent sizing and padding
/// 
/// Styles:
/// - [suggested]: Primary action, accent background
/// - [default]: Secondary action, neutral background
/// - [destructive]: Dangerous action, red background
/// - [flat]: Tertiary action, transparent with text color
enum GnomeButtonStyle {
  suggested,   // Primary - accent color
  default_,    // Secondary - neutral
  destructive, // Danger - red
  flat,        // Tertiary - transparent
}

/// A button following GNOME design principles
class GnomeButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget? child;
  final String? label;
  final IconData? icon;
  final GnomeButtonStyle style;
  final bool isLoading;
  final bool isExpanded;
  final EdgeInsets? padding;
  final double? height;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;

  const GnomeButton({
    super.key,
    this.onPressed,
    this.onLongPress,
    this.child,
    this.label,
    this.icon,
    this.style = GnomeButtonStyle.default_,
    this.isLoading = false,
    this.isExpanded = false,
    this.padding,
    this.height,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
  }) : assert(
         child != null || label != null,
         'Either child or label must be provided',
       );

  /// Suggested action button (primary)
  const GnomeButton.suggested({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.child,
    this.label,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.padding,
    this.height,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
  }) : style = GnomeButtonStyle.suggested;

  /// Destructive action button
  const GnomeButton.destructive({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.child,
    this.label,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.padding,
    this.height,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
  }) : style = GnomeButtonStyle.destructive;

  /// Flat button (tertiary action)
  const GnomeButton.flat({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.child,
    this.label,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.padding,
    this.height,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
  }) : style = GnomeButtonStyle.flat;

  @override
  State<GnomeButton> createState() => _GnomeButtonState();
}

class _GnomeButtonState extends State<GnomeButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: GnomeAnimations.micro,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _pressController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _pressController.reverse();
  }

  void _handleTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Determine colors based on style
    final colors = _getButtonColors(theme, isDark);
    
    // Build the button content
    Widget content = widget.child ?? _buildDefaultContent(colors.foreground);
    
    // Wrap with loading indicator if needed
    if (widget.isLoading) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colors.foreground),
            ),
          ),
          if (widget.label != null) ...[
            const SizedBox(width: 8),
            Text(
              widget.label!,
              style: TextStyle(
                color: colors.foreground,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      );
    }
    
    // Apply scale animation
    content = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: content,
    );
    
    // Build the button container
    Widget button = Material(
      color: colors.background,
      borderRadius: GnomeShapes.buttonBorderRadius,
      clipBehavior: GnomeShapes.buttonClip,
      child: InkWell(
        onTap: widget.isLoading ? null : widget.onPressed,
        onLongPress: widget.isLoading ? null : widget.onLongPress,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        splashColor: colors.splash,
        highlightColor: colors.highlight,
        child: Container(
          height: widget.height ?? 44,
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: content,
        ),
      ),
    );
    
    // Add border if needed
    if (colors.border != null) {
      button = Container(
        decoration: BoxDecoration(
          borderRadius: GnomeShapes.buttonBorderRadius,
          border: Border.all(color: colors.border!, width: 1),
        ),
        child: button,
      );
    }
    
    // Expand if requested
    if (widget.isExpanded) {
      button = SizedBox(width: double.infinity, child: button);
    }
    
    return button;
  }

  Widget _buildDefaultContent(Color foreground) {
    if (widget.icon != null && widget.label != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, size: 18, color: foreground),
          const SizedBox(width: 8),
          Text(
            widget.label!,
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      );
    } else if (widget.icon != null) {
      return Icon(widget.icon, size: 20, color: foreground);
    } else if (widget.label != null) {
      return Text(
        widget.label!,
        style: TextStyle(
          color: foreground,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  _ButtonColors _getButtonColors(ThemeData theme, bool isDark) {
    switch (widget.style) {
      case GnomeButtonStyle.suggested:
        return _ButtonColors(
          background: theme.colorScheme.primary,
          foreground: theme.colorScheme.onPrimary,
          splash: Colors.white.withOpacity(0.2),
          highlight: Colors.white.withOpacity(0.1),
          border: null,
        );
        
      case GnomeButtonStyle.destructive:
        return _ButtonColors(
          background: isDark ? GnomeColorsDark.destructive : GnomeColors.destructive,
          foreground: Colors.white,
          splash: Colors.white.withOpacity(0.2),
          highlight: Colors.white.withOpacity(0.1),
          border: null,
        );
        
      case GnomeButtonStyle.flat:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: theme.colorScheme.primary,
          splash: theme.colorScheme.primary.withOpacity(0.1),
          highlight: theme.colorScheme.primary.withOpacity(0.05),
          border: null,
        );
        
      case GnomeButtonStyle.default_:
      default:
        return _ButtonColors(
          background: isDark 
              ? GnomeColorsDark.sidebarBg 
              : GnomeColors.sidebarBg,
          foreground: isDark 
              ? GnomeColorsDark.windowFg 
              : GnomeColors.windowFg,
          splash: (isDark ? GnomeColorsDark.windowFg : GnomeColors.windowFg)
              .withOpacity(0.1),
          highlight: (isDark ? GnomeColorsDark.windowFg : GnomeColors.windowFg)
              .withOpacity(0.05),
          border: isDark ? GnomeColorsDark.border : GnomeColors.border,
        );
    }
  }
}

class _ButtonColors {
  final Color background;
  final Color foreground;
  final Color splash;
  final Color highlight;
  final Color? border;

  _ButtonColors({
    required this.background,
    required this.foreground,
    required this.splash,
    required this.highlight,
    this.border,
  });
}

/// Icon-only button for toolbars and compact layouts
class GnomeIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final Color? color;
  final double size;
  final EdgeInsets padding;

  const GnomeIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.color,
    this.size = 24,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = color ?? theme.iconTheme.color;
    
    Widget button = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(GnomeShapes.iconButtonRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(GnomeShapes.iconButtonRadius),
        child: Padding(
          padding: padding,
          child: Icon(icon, size: size, color: iconColor),
        ),
      ),
    );
    
    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }
    
    return button;
  }
}
