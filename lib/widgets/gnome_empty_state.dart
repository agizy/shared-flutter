import 'package:flutter/material.dart';
import '../design/gnome_theme.dart';
import 'gnome_button.dart';

/// GNOME-style empty state widget
/// 
/// 80/20 Rule: Empty states should guide users, not decorate
/// - Large, muted icon (center of attention)
/// - Clear title explaining the empty state
/// - Optional description with guidance
/// - Optional primary action button
/// - No decorative illustrations or animations
/// 
/// Use for: empty lists, no search results, first-run states
class GnomeEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? customAction;
  final double iconSize;
  final EdgeInsets padding;

  const GnomeEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    this.customAction,
    this.iconSize = 64,
    this.padding = const EdgeInsets.all(32),
  });

  /// Create an empty state for search results
  factory GnomeEmptyState.search({
    Key? key,
    required String query,
    String? description,
    VoidCallback? onClear,
  }) {
    return GnomeEmptyState(
      key: key,
      icon: Icons.search_off,
      title: 'No results for "$query"',
      description: description ?? 'Try a different search term',
      actionLabel: onClear != null ? 'Clear search' : null,
      onAction: onClear,
    );
  }

  /// Create an empty state for lists
  factory GnomeEmptyState.list({
    Key? key,
    required String itemType,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return GnomeEmptyState(
      key: key,
      icon: Icons.inbox_outlined,
      title: 'No $itemType yet',
      description: 'Get started by adding your first $itemType',
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Create an empty state for errors
  factory GnomeEmptyState.error({
    Key? key,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return GnomeEmptyState(
      key: key,
      icon: Icons.error_outline,
      title: 'Something went wrong',
      description: message,
      actionLabel: actionLabel ?? 'Retry',
      onAction: onAction,
    );
  }

  /// Create an empty state for offline
  factory GnomeEmptyState.offline({
    Key? key,
    VoidCallback? onRetry,
  }) {
    return GnomeEmptyState(
      key: key,
      icon: Icons.cloud_off,
      title: 'You\'re offline',
      description: 'Check your connection and try again',
      actionLabel: 'Retry',
      onAction: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final mutedColor = isDark 
        ? GnomeColorsDark.dim 
        : GnomeColors.dim;
    
    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            Icon(
              icon,
              size: iconSize,
              color: mutedColor,
            ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: isDark ? GnomeColorsDark.windowFg : GnomeColors.windowFg,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Description
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: mutedColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            // Action
            if (customAction != null) ...[
              const SizedBox(height: 24),
              customAction!,
            ] else if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              GnomeButton.suggested(
                onPressed: onAction,
                label: actionLabel,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A compact empty state for inline use (e.g., in cards)
class GnomeEmptyStateCompact extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final EdgeInsets padding;

  const GnomeEmptyStateCompact({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final mutedColor = isDark 
        ? GnomeColorsDark.dim 
        : GnomeColors.dim;
    
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Icon(
            icon,
            size: 32,
            color: mutedColor,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark ? GnomeColorsDark.windowFg : GnomeColors.windowFg,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (description != null)
                  Text(
                    description!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: mutedColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
