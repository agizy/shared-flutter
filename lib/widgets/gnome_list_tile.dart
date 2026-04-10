import 'package:flutter/material.dart';
// import '../design/gnome_animations.dart';
import '../design/gnome_shapes.dart';
import '../design/gnome_theme.dart';

/// GNOME-style list tile widget
/// 
/// 80/20 Rule: List items should be scannable and actionable
/// - 6px corner radius per item
/// - Clear visual hierarchy: icon > title > subtitle > trailing
/// - Selection state with accent background
/// - Consistent padding (16px horizontal, 12px vertical)
///
/// Use for: settings items, file lists, menu items, selectable lists
class GnomeListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final String? titleText;
  final Widget? subtitle;
  final String? subtitleText;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool selected;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;
  final Color? backgroundColor;
  final Color? selectedColor;
  final double? leadingSize;
  final double minHeight;

  const GnomeListTile({
    super.key,
    this.leading,
    this.title,
    this.titleText,
    this.subtitle,
    this.subtitleText,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.enabled = true,
    this.contentPadding,
    this.backgroundColor,
    this.selectedColor,
    this.leadingSize,
    this.minHeight = 52,
  }) : assert(
         title != null || titleText != null,
         'Either title or titleText must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Build title widget
    final titleWidget = title ?? Text(
      titleText!,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: enabled 
            ? (isDark ? GnomeColorsDark.windowFg : GnomeColors.windowFg)
            : (isDark ? GnomeColorsDark.dim : GnomeColors.dim),
      ),
    );
    
    // Build subtitle widget
    final Widget? subtitleWidget = subtitle ?? (subtitleText != null
        ? Text(
            subtitleText!,
            style: TextStyle(
              fontSize: 13,
              color: enabled
                  ? (isDark ? GnomeColorsDark.dim : GnomeColors.dim)
                  : (isDark ? GnomeColorsDark.dim.withOpacity(0.5) : GnomeColors.dim.withOpacity(0.5)),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        : null);
    
    // Determine background color
    final bgColor = selected
        ? (selectedColor ?? theme.colorScheme.primary.withOpacity(isDark ? 0.2 : 0.1))
        : backgroundColor ?? Colors.transparent;
    
    // Build content
    Widget content = Row(
      children: [
        if (leading != null) ...[
          SizedBox(
            width: leadingSize ?? 40,
            height: leadingSize ?? 40,
            child: Center(child: leading),
          ),
          const SizedBox(width: 12),
        ] else
          const SizedBox(width: 16),
          
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              titleWidget,
              if (subtitleWidget != null) ...[
                const SizedBox(height: 2),
                subtitleWidget,
              ],
            ],
          ),
        ),
        
        if (trailing != null) ...[
          const SizedBox(width: 12),
          trailing!,
        ],
        
        const SizedBox(width: 16),
      ],
    );
    
    // Apply min height
    content = ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Center(
        widthFactor: 1,
        child: content,
      ),
    );
    
    // Wrap with padding
    content = Padding(
      padding: contentPadding ?? EdgeInsets.zero,
      child: content,
    );
    
    // Add inkwell for tap
    if (onTap != null || onLongPress != null) {
      content = InkWell(
        onTap: enabled ? onTap : null,
        onLongPress: enabled ? onLongPress : null,
        borderRadius: GnomeShapes.listItemBorderRadius,
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        child: content,
      );
    }
    
    // Add background container
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: GnomeShapes.listItemBorderRadius,
      ),
      child: content,
    );
  }
}

/// A group of list tiles with consistent styling
class GnomeListGroup extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double spacing;

  const GnomeListGroup({
    super.key,
    this.title,
    required this.children,
    this.padding,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title!,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: children.map((child) {
              return Padding(
                padding: EdgeInsets.only(bottom: spacing),
                child: child,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// A selectable list tile with checkbox
class GnomeCheckboxListTile extends StatelessWidget {
  final Widget? title;
  final String? titleText;
  final Widget? subtitle;
  final String? subtitleText;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final bool tristate;
  final EdgeInsetsGeometry? contentPadding;

  const GnomeCheckboxListTile({
    super.key,
    this.title,
    this.titleText,
    this.subtitle,
    this.subtitleText,
    required this.value,
    this.onChanged,
    this.tristate = false,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GnomeListTile(
      title: title,
      titleText: titleText,
      subtitle: subtitle,
      subtitleText: subtitleText,
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      contentPadding: contentPadding,
      leading: SizedBox(
        width: 24,
        height: 24,
        child: Checkbox(
          value: value,
          tristate: tristate,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      leadingSize: 24,
    );
  }
}

/// A selectable list tile with radio button
class GnomeRadioListTile<T> extends StatelessWidget {
  final Widget? title;
  final String? titleText;
  final Widget? subtitle;
  final String? subtitleText;
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final EdgeInsetsGeometry? contentPadding;

  const GnomeRadioListTile({
    super.key,
    this.title,
    this.titleText,
    this.subtitle,
    this.subtitleText,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    
    return GnomeListTile(
      title: title,
      titleText: titleText,
      subtitle: subtitle,
      subtitleText: subtitleText,
      onTap: onChanged != null ? () => onChanged!(value) : null,
      contentPadding: contentPadding,
      selected: isSelected,
      leading: SizedBox(
        width: 24,
        height: 24,
        child: Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      leadingSize: 24,
    );
  }
}

/// A list tile with a switch
class GnomeSwitchListTile extends StatelessWidget {
  final Widget? title;
  final String? titleText;
  final Widget? subtitle;
  final String? subtitleText;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final EdgeInsetsGeometry? contentPadding;

  const GnomeSwitchListTile({
    super.key,
    this.title,
    this.titleText,
    this.subtitle,
    this.subtitleText,
    required this.value,
    this.onChanged,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GnomeListTile(
      title: title,
      titleText: titleText,
      subtitle: subtitle,
      subtitleText: subtitleText,
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      contentPadding: contentPadding,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
