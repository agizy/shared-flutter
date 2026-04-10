import 'package:flutter/material.dart';
import '../design/gnome_theme.dart';

/// GNOME-style loading indicators
/// 
/// 80/20 Rule: Loading states should be clear but unobtrusive
/// - Progress indicators without excessive text
/// - Skeleton placeholders for content
/// - Subtle animations (no bouncing or spinning flourishes)
/// 
/// Use for: initial loading, pagination, async operations

/// A circular loading indicator following GNOME style
class GnomeLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
  final String? semanticsLabel;

  const GnomeLoadingIndicator({
    super.key,
    this.size = 32,
    this.color,
    this.strokeWidth = 3,
    this.semanticsLabel,
  });

  /// Small indicator for inline use
  const GnomeLoadingIndicator.small({
    super.key,
    this.color,
    this.semanticsLabel,
  }) : size = 16,
       strokeWidth = 2;

  /// Large indicator for full-screen use
  const GnomeLoadingIndicator.large({
    super.key,
    this.color,
    this.semanticsLabel,
  }) : size = 48,
       strokeWidth = 4;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = color ?? theme.colorScheme.primary;
    
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
        semanticsLabel: semanticsLabel,
      ),
    );
  }
}

/// A linear loading indicator
class GnomeLinearProgress extends StatelessWidget {
  final double? value;
  final double height;
  final Color? backgroundColor;
  final Color? valueColor;
  final BorderRadius? borderRadius;

  const GnomeLinearProgress({
    super.key,
    this.value,
    this.height = 4,
    this.backgroundColor,
    this.valueColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        backgroundColor: backgroundColor ?? (isDark 
            ? GnomeColorsDark.sidebarBg 
            : GnomeColors.sidebarBg),
        valueColor: AlwaysStoppedAnimation<Color>(
          valueColor ?? theme.colorScheme.primary,
        ),
      ),
    );
  }
}

/// A full-screen loading overlay
class GnomeLoadingOverlay extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;

  const GnomeLoadingOverlay({
    super.key,
    this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      color: backgroundColor ?? (isDark 
          ? GnomeColorsDark.windowBg.withOpacity(0.9)
          : GnomeColors.windowBg.withOpacity(0.9)),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const GnomeLoadingIndicator.large(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? GnomeColorsDark.dim : GnomeColors.dim,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A skeleton placeholder for loading content
/// 
/// Subtle pulsing animation, less aggressive than shimmer
class GnomeSkeleton extends StatefulWidget {
  final double width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  const GnomeSkeleton({
    super.key,
    required this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  /// Skeleton for text lines
  const GnomeSkeleton.text({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius,
  }) : shape = BoxShape.rectangle;

  /// Skeleton for circular elements (avatars)
  const GnomeSkeleton.circle({
    super.key,
    required double size,
  }) : width = size,
       height = size,
       borderRadius = null,
       shape = BoxShape.circle;

  @override
  State<GnomeSkeleton> createState() => _GnomeSkeletonState();
}

class _GnomeSkeletonState extends State<GnomeSkeleton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _opacityAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = isDark ? GnomeColorsDark.sidebarBg : GnomeColors.sidebarBg;
    
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: baseColor.withOpacity(_opacityAnimation.value),
            borderRadius: widget.shape == BoxShape.rectangle
                ? (widget.borderRadius ?? BorderRadius.circular(4))
                : null,
            shape: widget.shape,
          ),
        );
      },
    );
  }
}

/// A skeleton layout for cards
class GnomeSkeletonCard extends StatelessWidget {
  final int lines;

  const GnomeSkeletonCard({
    super.key,
    this.lines = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GnomeSkeleton(width: double.infinity, height: 20),
            const SizedBox(height: 12),
            for (var i = 0; i < lines; i++) ...[
              GnomeSkeleton(
                width: i == lines - 1 ? 150 : double.infinity,
                height: 14,
              ),
              if (i < lines - 1) const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

/// A skeleton layout for list items
class GnomeSkeletonListItem extends StatelessWidget {
  final bool hasSubtitle;
  final bool hasLeading;

  const GnomeSkeletonListItem({
    super.key,
    this.hasSubtitle = true,
    this.hasLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: hasLeading
          ? const GnomeSkeleton.circle(size: 40)
          : null,
      title: const GnomeSkeleton(width: double.infinity, height: 16),
      subtitle: hasSubtitle
          ? const GnomeSkeleton(width: 150, height: 14)
          : null,
    );
  }
}
