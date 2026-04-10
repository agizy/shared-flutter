import 'package:flutter/material.dart';
import '../design/gnome_shapes.dart';
import '../design/gnome_theme.dart';

/// A simple icon button following GNOME design
class GnomeIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final Color? color;
  final double size;
  final EdgeInsets padding;
  final bool isSelected;

  const GnomeIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.color,
    this.size = 24,
    this.padding = const EdgeInsets.all(8),
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final iconColor = color ?? (isSelected
        ? theme.colorScheme.primary
        : (isDark ? GnomeColorsDark.windowFg : GnomeColors.windowFg));
    
    final bgColor = isSelected
        ? theme.colorScheme.primary.withOpacity(isDark ? 0.2 : 0.1)
        : Colors.transparent;
    
    Widget button = Material(
      color: bgColor,
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
