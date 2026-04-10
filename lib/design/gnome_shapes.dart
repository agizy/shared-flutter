import 'package:flutter/material.dart';

/// GNOME-inspired shape system
/// Consistent border radii and shapes across the app suite
/// 
/// 80/20 Rule: Consistent, subtle rounding - not too sharp, not too round
/// - Cards: 12px (noticeable but not playful)
/// - Buttons: 6px (subtle, professional)
/// - Inputs: 6px (matches buttons)
/// - Pills: Full rounded (tags, filters)

class GnomeShapes {
  GnomeShapes._();
  
  // ===========================================================================
  // BORDER RADII
  // ===========================================================================
  
  /// Window/dialog radius
  /// Used for: Dialogs, bottom sheets, modals
  static const double windowRadius = 12.0;
  
  /// Card radius
  /// Used for: Cards, containers, lists
  static const double cardRadius = 12.0;
  
  /// Button radius
  /// Used for: All buttons, action chips
  static const double buttonRadius = 6.0;
  
  /// Input radius
  /// Used for: Text fields, search bars
  static const double inputRadius = 6.0;
  
  /// List item radius
  /// Used for: List tiles, menu items
  static const double listItemRadius = 6.0;
  
  /// Chip radius (pill shape)
  /// Used for: Filter chips, tags
  static const double chipRadius = 9999.0;
  
  /// Avatar radius
  /// Used for: Profile pictures, circular icons
  static const double avatarRadius = 9999.0;
  
  /// Icon button radius
  /// Used for: Icon buttons, small actions
  static const double iconButtonRadius = 6.0;
  
  /// Floating action button radius
  /// Used for: FABs
  static const double fabRadius = 12.0;
  
  /// Snackbar radius
  /// Used for: Snackbars, toasts
  static const double snackbarRadius = 6.0;
  
  // ===========================================================================
  // BORDER RADIUS OBJECTS
  // ===========================================================================
  
  /// All corners rounded (window/dialog size)
  static BorderRadius get windowBorderRadius => 
      BorderRadius.circular(windowRadius);
  
  /// All corners rounded (card size)
  static BorderRadius get cardBorderRadius => 
      BorderRadius.circular(cardRadius);
  
  /// All corners rounded (button/input size)
  static BorderRadius get buttonBorderRadius => 
      BorderRadius.circular(buttonRadius);
  
  /// All corners rounded (list item size)
  static BorderRadius get listItemBorderRadius => 
      BorderRadius.circular(listItemRadius);
  
  /// Pill shape (full rounded)
  static BorderRadius get pillBorderRadius => 
      BorderRadius.circular(chipRadius);
  
  /// Top corners only (bottom sheets)
  static BorderRadius get topRounded => const BorderRadius.vertical(
        top: Radius.circular(windowRadius),
      );
  
  /// Bottom corners only
  static BorderRadius get bottomRounded => const BorderRadius.vertical(
        bottom: Radius.circular(windowRadius),
      );
  
  /// Left corners only
  static BorderRadius get leftRounded => const BorderRadius.horizontal(
        left: Radius.circular(buttonRadius),
      );
  
  /// Right corners only
  static BorderRadius get rightRounded => const BorderRadius.horizontal(
        right: Radius.circular(buttonRadius),
      );
  
  // ===========================================================================
  // SHAPE BORDERS
  // ===========================================================================
  
  /// Card shape with subtle border
  static RoundedRectangleBorder cardShape({Color? borderColor}) => 
      RoundedRectangleBorder(
        borderRadius: cardBorderRadius,
        side: borderColor != null 
            ? BorderSide(color: borderColor)
            : BorderSide.none,
      );
  
  /// Button shape
  static RoundedRectangleBorder buttonShape({Color? borderColor}) => 
      RoundedRectangleBorder(
        borderRadius: buttonBorderRadius,
        side: borderColor != null 
            ? BorderSide(color: borderColor)
            : BorderSide.none,
      );
  
  /// Input shape
  static RoundedRectangleBorder inputShape({Color? borderColor}) => 
      RoundedRectangleBorder(
        borderRadius: buttonBorderRadius,
        side: borderColor != null 
            ? BorderSide(color: borderColor)
            : BorderSide.none,
      );
  
  /// Pill shape (for chips)
  static RoundedRectangleBorder pillShape({Color? borderColor}) => 
      RoundedRectangleBorder(
        borderRadius: pillBorderRadius,
        side: borderColor != null 
            ? BorderSide(color: borderColor)
            : BorderSide.none,
      );
  
  /// Window/dialog shape
  static RoundedRectangleBorder windowShape({Color? borderColor}) => 
      RoundedRectangleBorder(
        borderRadius: windowBorderRadius,
        side: borderColor != null 
            ? BorderSide(color: borderColor)
            : BorderSide.none,
      );
  
  /// Circular avatar shape
  static CircleBorder get avatarShape => const CircleBorder();
  
  // ===========================================================================
  // OUTLINED SHAPES (with borders)
  // ===========================================================================
  
  /// Outlined card shape
  static ShapeBorder outlinedCard({
    required Color borderColor,
    double borderWidth = 1.0,
  }) => RoundedRectangleBorder(
    borderRadius: cardBorderRadius,
    side: BorderSide(color: borderColor, width: borderWidth),
  );
  
  /// Outlined button shape
  static ShapeBorder outlinedButton({
    required Color borderColor,
    double borderWidth = 1.0,
  }) => RoundedRectangleBorder(
    borderRadius: buttonBorderRadius,
    side: BorderSide(color: borderColor, width: borderWidth),
  );
  
  /// Outlined input shape
  static ShapeBorder outlinedInput({
    required Color borderColor,
    double borderWidth = 1.0,
  }) => RoundedRectangleBorder(
    borderRadius: buttonBorderRadius,
    side: BorderSide(color: borderColor, width: borderWidth),
  );
  
  // ===========================================================================
  // CONTAINER DECORATIONS
  // ===========================================================================
  
  /// Standard card decoration
  static BoxDecoration cardDecoration({
    Color? color,
    Color? borderColor,
    double borderWidth = 1.0,
    List<BoxShadow>? shadows,
  }) => BoxDecoration(
    color: color,
    borderRadius: cardBorderRadius,
    border: borderColor != null 
        ? Border.all(color: borderColor, width: borderWidth)
        : null,
    boxShadow: shadows,
  );
  
  /// Elevated card decoration (subtle shadow)
  static BoxDecoration elevatedCard({
    Color? color,
    Color? borderColor,
    Color shadowColor = Colors.black,
  }) => cardDecoration(
    color: color,
    borderColor: borderColor,
    shadows: [
      BoxShadow(
        color: shadowColor.withOpacity(0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  /// Button decoration
  static BoxDecoration buttonDecoration({
    Color? color,
    Color? borderColor,
  }) => BoxDecoration(
    color: color,
    borderRadius: buttonBorderRadius,
    border: borderColor != null 
        ? Border.all(color: borderColor)
        : null,
  );
  
  /// Input decoration container
  static BoxDecoration inputDecoration({
    Color? fillColor,
    Color? borderColor,
  }) => BoxDecoration(
    color: fillColor,
    borderRadius: buttonBorderRadius,
    border: borderColor != null 
        ? Border.all(color: borderColor)
        : null,
  );
  
  /// Chip decoration
  static BoxDecoration chipDecoration({
    Color? color,
    Color? borderColor,
  }) => BoxDecoration(
    color: color,
    borderRadius: pillBorderRadius,
    border: borderColor != null 
        ? Border.all(color: borderColor)
        : null,
  );
  
  /// Avatar decoration
  static BoxDecoration avatarDecoration({
    Color? backgroundColor,
    Color? borderColor,
    double borderWidth = 2.0,
  }) => BoxDecoration(
    color: backgroundColor,
    shape: BoxShape.circle,
    border: borderColor != null 
        ? Border.all(color: borderColor, width: borderWidth)
        : null,
  );
  
  // ===========================================================================
  // CLIP BEHAVIORS
  // ===========================================================================
  
  /// Clip for cards
  static Clip cardClip = Clip.antiAlias;
  
  /// Clip for buttons
  static Clip buttonClip = Clip.antiAlias;
  
  /// Clip for lists
  static Clip listClip = Clip.antiAlias;
}

/// Extension for easier shape application
extension ShapeExtensions on Widget {
  /// Wrap widget in card shape clip
  Widget clippedToCard() => ClipRRect(
        borderRadius: GnomeShapes.cardBorderRadius,
        clipBehavior: Clip.antiAlias,
        child: this,
      );
  
  /// Wrap widget in button shape clip
  Widget clippedToButton() => ClipRRect(
        borderRadius: GnomeShapes.buttonBorderRadius,
        clipBehavior: Clip.antiAlias,
        child: this,
      );
  
  /// Wrap widget in pill shape clip
  Widget clippedToPill() => ClipRRect(
        borderRadius: GnomeShapes.pillBorderRadius,
        clipBehavior: Clip.antiAlias,
        child: this,
      );
}
