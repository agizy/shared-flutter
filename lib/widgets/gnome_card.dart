import 'package:flutter/material.dart';
// import '../design/gnome_animations.dart';
import '../design/gnome_shapes.dart';

/// GNOME-style card widget
/// 
/// 80/20 Rule: Cards should frame content without distraction
/// - Subtle border or minimal elevation
/// - 12px corner radius (consistent across the suite)
/// - No heavy shadows or gradients
/// - Optional: tap interaction with ripple
/// 
/// Use for: content containers, list items, settings groups
class GnomeCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Clip clipBehavior;
  final bool isSelected;
  final Widget? trailing;

  const GnomeCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
    this.isSelected = false,
    this.trailing,
  });

  /// Create a card with a title header
  factory GnomeCard.withTitle({
    Key? key,
    required String title,
    required Widget child,
    Widget? leading,
    Widget? trailing,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return GnomeCard(
      key: key,
      margin: margin,
      onTap: onTap,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
          Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Determine colors
    final bgColor = backgroundColor ?? theme.cardTheme.color;
    final border = borderColor ?? (
      isSelected 
          ? theme.colorScheme.primary.withOpacity(0.5)
          : theme.dividerTheme.color?.withOpacity(0.5)
    );
    final cardElevation = elevation ?? (isSelected ? 2.0 : 0.0);
    
    // Build card content
    Widget cardContent = Container(
      padding: padding ?? const EdgeInsets.all(16),
      child: trailing != null
          ? Row(
              children: [
                Expanded(child: child),
                const SizedBox(width: 12),
                trailing!,
              ],
            )
          : child,
    );
    
    // Add tap interaction if needed
    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? GnomeShapes.cardBorderRadius,
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        child: cardContent,
      );
    }
    
    // Build the card
    Widget card = Material(
      color: bgColor,
      elevation: cardElevation!,
      shadowColor: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.1),
      borderRadius: borderRadius ?? GnomeShapes.cardBorderRadius,
      clipBehavior: clipBehavior,
      child: cardContent,
    );
    
    // Add border container
    if (border != null || isSelected) {
      card = Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? GnomeShapes.cardBorderRadius,
          border: Border.all(
            color: border ?? theme.colorScheme.primary.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: card,
      );
    }
    
    // Add margin
    if (margin != null) {
      card = Padding(padding: margin!, child: card);
    }
    
    return card;
  }
}

/// A list of cards with consistent spacing
class GnomeCardList extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final bool shrinkWrap;

  const GnomeCardList({
    super.key,
    required this.children,
    this.padding,
    this.spacing = 12,
    this.shrinkWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? const EdgeInsets.all(16),
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: children.length,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// A row of cards that scroll horizontally
class GnomeCardRow extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final double? cardWidth;

  const GnomeCardRow({
    super.key,
    required this.children,
    this.padding,
    this.spacing = 12,
    this.cardWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardWidth != null ? null : 160,
      child: ListView.separated(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        separatorBuilder: (context, index) => SizedBox(width: spacing),
        itemBuilder: (context, index) {
          if (cardWidth != null) {
            return SizedBox(width: cardWidth, child: children[index]);
          }
          return children[index];
        },
      ),
    );
  }
}
