import 'package:flutter/material.dart';
import '../design/gnome_theme.dart';
import 'gnome_icon_button.dart';

/// GNOME-style app bar widget
/// 
/// 80/20 Rule: App bars should provide context and navigation
/// - Clean title, left-aligned or centered
/// - Subtle bottom border (not shadow)
/// - Actions in overflow menu when possible
/// - Back button with simple arrow
/// 
/// Use for: primary navigation, page headers, modal headers
class GnomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final BorderSide? bottomBorder;
  final PreferredSizeWidget? bottom;
  final double toolbarHeight;

  const GnomeAppBar({
    super.key,
    this.title,
    this.titleText,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.bottomBorder,
    this.bottom,
    this.toolbarHeight = kToolbarHeight,
  });

  /// Create a simple app bar with just a title
  factory GnomeAppBar.simple(
    String title, {
    Key? key,
    List<Widget>? actions,
    Widget? leading,
  }) {
    return GnomeAppBar(
      key: key,
      titleText: title,
      actions: actions,
      leading: leading,
    );
  }

  /// Create an app bar with a back button
  factory GnomeAppBar.withBack(
    BuildContext context, {
    Key? key,
    String? title,
    VoidCallback? onBack,
    List<Widget>? actions,
  }) {
    return GnomeAppBar(
      key: key,
      titleText: title,
      leading: GnomeIconButton(
        icon: Icons.arrow_back,
        onPressed: onBack ?? () => Navigator.pop(context),
        tooltip: 'Back',
      ),
      automaticallyImplyLeading: false,
      actions: actions,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final modalRoute = ModalRoute.of(context);
    
    // Determine if we should show back button
    final canPop = modalRoute?.canPop ?? false;
    final useCloseButton = modalRoute is PageRoute && modalRoute.fullscreenDialog;
    
    // Build leading widget
    Widget? leadingWidget = leading;
    if (leadingWidget == null && automaticallyImplyLeading && canPop) {
      leadingWidget = GnomeIconButton(
        icon: useCloseButton ? Icons.close : Icons.arrow_back,
        onPressed: () => Navigator.pop(context),
        tooltip: useCloseButton ? 'Close' : 'Back',
      );
    }
    
    // Build title
    final titleWidget = title ?? (titleText != null
        ? Text(
            titleText!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: foregroundColor ?? (isDark 
                  ? GnomeColorsDark.windowFg 
                  : GnomeColors.windowFg),
            ),
          )
        : null);
    
    // Build actions
    final actionWidgets = actions ?? [];
    
    return AppBar(
      title: titleWidget,
      leading: leadingWidget,
      automaticallyImplyLeading: false, // We handle this manually
      actions: actionWidgets.isNotEmpty ? actionWidgets : null,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? (isDark 
          ? GnomeColorsDark.headerBg 
          : GnomeColors.headerBg),
      foregroundColor: foregroundColor ?? (isDark 
          ? GnomeColorsDark.headerFg 
          : GnomeColors.headerFg),
      elevation: elevation,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      bottom: bottom ?? (bottomBorder != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  border: Border(bottom: bottomBorder!),
                ),
              ),
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                color: isDark 
                    ? GnomeColorsDark.headerBorder 
                    : GnomeColors.headerBorder,
              ),
            )),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    toolbarHeight + (bottom?.preferredSize.height ?? 1),
  );
}

/// A search app bar with integrated search field
class GnomeSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final List<Widget>? actions;
  final bool autofocus;

  const GnomeSearchAppBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.actions,
    this.autofocus = false,
  });

  @override
  State<GnomeSearchAppBar> createState() => _GnomeSearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

class _GnomeSearchAppBarState extends State<GnomeSearchAppBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
    widget.onChanged?.call(_controller.text);
  }

  void _clear() {
    _controller.clear();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AppBar(
      leading: GnomeIconButton(
        icon: Icons.arrow_back,
        onPressed: () => Navigator.pop(context),
        tooltip: 'Back',
      ),
      title: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Search...',
          hintStyle: TextStyle(
            color: isDark ? GnomeColorsDark.dim : GnomeColors.dim,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          suffixIcon: _hasText
              ? GnomeIconButton(
                  icon: Icons.clear,
                  onPressed: _clear,
                  tooltip: 'Clear',
                  size: 20,
                )
              : null,
        ),
        style: TextStyle(
          color: isDark ? GnomeColorsDark.windowFg : GnomeColors.windowFg,
          fontSize: 16,
        ),
        onSubmitted: widget.onSubmitted,
      ),
      actions: widget.actions,
      backgroundColor: isDark ? GnomeColorsDark.headerBg : GnomeColors.headerBg,
      foregroundColor: isDark ? GnomeColorsDark.headerFg : GnomeColors.headerFg,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark ? GnomeColorsDark.headerBorder : GnomeColors.headerBorder,
        ),
      ),
    );
  }
}
