import 'package:flutter/material.dart';

/// GNOME Libadwaita-inspired design system for Flutter
/// Implements the 80/20 rule: 80% functionality, 20% decoration
/// 
/// Based on GNOME 45+ Libadwaita color palette and design principles

/// Light theme colors (Libadwaita)
class GnomeColors {
  // Window/Chrome
  static const windowBg = Color(0xFFFAFAFB);
  static const windowFg = Color(0xCC000006); // 80% opacity black
  static const backdropBg = Color(0xFFF2F2F3);
  
  // Views/Content Areas
  static const viewBg = Color(0xFFFFFFFF);
  static const viewFg = Color(0xCC000006);
  
  // Header bars
  static const headerBg = Color(0xFFFFFFFF);
  static const headerFg = Color(0xCC000006);
  static const headerBackdrop = Color(0xFFFAFAFB);
  static const headerBorder = Color(0x1F000006); // 12% opacity
  static const headerShade = Color(0x1F000006);
  
  // Sidebars
  static const sidebarBg = Color(0xFFEBEBED);
  static const sidebarFg = Color(0xCC000006);
  static const sidebarBorder = Color(0x12000006); // 7% opacity
  static const sidebarBackdrop = Color(0xFFEBEBED);
  
  // Cards/Boxed lists
  static const cardBg = Color(0xFFFFFFFF);
  static const cardFg = Color(0xCC000006);
  static const cardShade = Color(0x12000006);
  
  // Popovers/Dialogs
  static const popoverBg = Color(0xFFFFFFFF);
  static const popoverFg = Color(0xCC000006);
  static const dialogBg = Color(0xFFFAFAFB);
  
  // General shades
  static const shade = Color(0x12000006);
  static const dim = Color(0x8C000006); // 55% opacity
  static const border = Color(0x26000006); // 15% opacity
  
  // Accent colors (9 GNOME standard accents)
  static const blue = Color(0xFF3584E4);
  static const teal = Color(0xFF2190A4);
  static const green = Color(0xFF3A944A);
  static const yellow = Color(0xFFC88800);
  static const orange = Color(0xFFED5B00);
  static const red = Color(0xFFE01B24);
  static const pink = Color(0xFFD56199);
  static const purple = Color(0xFF9141AC);
  static const slate = Color(0xFF6F8396);
  
  // Semantic colors
  static const success = Color(0xFF2EC27E);
  static const warning = Color(0xFFE5A50A);
  static const error = Color(0xFFE01B24);
  static const destructive = Color(0xFFE01B24);
  
  // Full palette (5 shades per color)
  static const blue1 = Color(0xFF99C1F1);
  static const blue2 = Color(0xFF62A0EA);
  static const blue3 = Color(0xFF3584E4);
  static const blue4 = Color(0xFF1C71D8);
  static const blue5 = Color(0xFF1A5FB4);
  
  static const green1 = Color(0xFF8FF0A4);
  static const green2 = Color(0xFF57E389);
  static const green3 = Color(0xFF33D17A);
  static const green4 = Color(0xFF2EC27E);
  static const green5 = Color(0xFF26A269);
  
  static const yellow1 = Color(0xFFF9F06B);
  static const yellow2 = Color(0xFFF8E45C);
  static const yellow3 = Color(0xFFF6D32D);
  static const yellow4 = Color(0xFFF5C211);
  static const yellow5 = Color(0xFFE5A50A);
  
  static const red1 = Color(0xFFF66151);
  static const red2 = Color(0xFFED333B);
  static const red3 = Color(0xFFE01B24);
  static const red4 = Color(0xFFC01C28);
  static const red5 = Color(0xFFA51D2D);
  
  // Neutral grays (light theme)
  static const gray1 = Color(0xFFFFFFFF);
  static const gray2 = Color(0xFFF6F5F4);
  static const gray3 = Color(0xFFDEDDDD);
  static const gray4 = Color(0xFFC0BFBC);
  static const gray5 = Color(0xFF9A9996);
  static const gray6 = Color(0xFF77767B);
  static const gray7 = Color(0xFF5E5C64);
  static const gray8 = Color(0xFF3D3846);
  static const gray9 = Color(0xFF241F31);
  static const black = Color(0xFF000000);
}

/// Dark theme colors
class GnomeColorsDark {
  static const windowBg = Color(0xFF222226);
  static const windowFg = Color(0xFFFFFFFF);
  static const backdropBg = Color(0xFF1A1A1C);
  
  static const viewBg = Color(0xFF1D1D20);
  static const viewFg = Color(0xFFFFFFFF);
  
  static const headerBg = Color(0xFF2E2E32);
  static const headerFg = Color(0xFFFFFFFF);
  static const headerBackdrop = Color(0xFF222226);
  static const headerBorder = Color(0x5C000006); // 36% opacity
  static const headerShade = Color(0x5C000006);
  
  static const sidebarBg = Color(0xFF2E2E32);
  static const sidebarFg = Color(0xFFFFFFFF);
  static const sidebarBorder = Color(0x5C000006);
  static const sidebarBackdrop = Color(0xFF2E2E32);
  
  static const cardBg = Color(0x14FFFFFF); // 8% opacity white
  static const cardFg = Color(0xFFFFFFFF);
  static const cardShade = Color(0x5C000006);
  
  static const popoverBg = Color(0xFF36363A);
  static const popoverFg = Color(0xFFFFFFFF);
  static const dialogBg = Color(0xFF36363A);
  
  static const shade = Color(0x40000006); // 25% opacity
  static const dim = Color(0x8CFFFFFF); // 55% opacity white
  static const border = Color(0x26FFFFFF); // 15% opacity
  
  // Accents (lighter in dark mode for visibility)
  static const blue = Color(0xFF81D0FF);
  static const teal = Color(0xFF7BDFF4);
  static const green = Color(0xFF8DE698);
  static const yellow = Color(0xFFFFC057);
  static const orange = Color(0xFFFF9C5B);
  static const red = Color(0xFFFF888C);
  static const pink = Color(0xFFFFA0D8);
  static const purple = Color(0xFFFBA7FF);
  static const slate = Color(0xFFBBD1E5);
  
  static const success = Color(0xFF78E9AB);
  static const warning = Color(0xFFFFC252);
  static const error = Color(0xFFFF938C);
  static const destructive = Color(0xFFFF938C);
}

/// 9 GNOME accent color options
enum GnomeAccent {
  blue,
  teal,
  green,
  yellow,
  orange,
  red,
  pink,
  purple,
  slate,
}

/// Extension to get accent colors
extension GnomeAccentColors on GnomeAccent {
  Color get lightColor {
    switch (this) {
      case GnomeAccent.blue: return GnomeColors.blue;
      case GnomeAccent.teal: return GnomeColors.teal;
      case GnomeAccent.green: return GnomeColors.green;
      case GnomeAccent.yellow: return GnomeColors.yellow;
      case GnomeAccent.orange: return GnomeColors.orange;
      case GnomeAccent.red: return GnomeColors.red;
      case GnomeAccent.pink: return GnomeColors.pink;
      case GnomeAccent.purple: return GnomeColors.purple;
      case GnomeAccent.slate: return GnomeColors.slate;
    }
  }
  
  Color get darkColor {
    switch (this) {
      case GnomeAccent.blue: return GnomeColorsDark.blue;
      case GnomeAccent.teal: return GnomeColorsDark.teal;
      case GnomeAccent.green: return GnomeColorsDark.green;
      case GnomeAccent.yellow: return GnomeColorsDark.yellow;
      case GnomeAccent.orange: return GnomeColorsDark.orange;
      case GnomeAccent.red: return GnomeColorsDark.red;
      case GnomeAccent.pink: return GnomeColorsDark.pink;
      case GnomeAccent.purple: return GnomeColorsDark.purple;
      case GnomeAccent.slate: return GnomeColorsDark.slate;
    }
  }
  
  Color colorFor(Brightness brightness) {
    return brightness == Brightness.dark ? darkColor : lightColor;
  }
}

/// Complete theme data generator
class GnomeTheme {
  static ThemeData light({
    GnomeAccent accent = GnomeAccent.blue,
    TargetPlatform? platform,
  }) {
    final accentColor = accent.lightColor;
    final colorScheme = ColorScheme.light(
      primary: accentColor,
      onPrimary: Colors.white,
      secondary: accentColor,
      onSecondary: Colors.white,
      surface: GnomeColors.windowBg,
      onSurface: GnomeColors.windowFg,
      surfaceContainerHighest: GnomeColors.sidebarBg,
      onSurfaceVariant: GnomeColors.sidebarFg,
      error: GnomeColors.error,
      onError: Colors.white,
      outline: GnomeColors.border,
      shadow: Colors.black.withOpacity(0.1),
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      platform: platform,
      brightness: Brightness.light,
      
      // Scaffold
      scaffoldBackgroundColor: GnomeColors.windowBg,
      
      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: GnomeColors.headerBg,
        foregroundColor: GnomeColors.headerFg,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(color: GnomeColors.headerBorder),
        ),
        titleTextStyle: TextStyle(
          color: GnomeColors.headerFg,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Cards
      cardTheme: CardThemeData(
        elevation: 0,
        color: GnomeColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: GnomeColors.cardShade),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          minimumSize: const Size(0, 44),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: GnomeColors.windowFg,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          side: BorderSide(color: GnomeColors.border),
          minimumSize: const Size(0, 44),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          minimumSize: const Size(0, 44),
        ),
      ),
      
      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GnomeColors.viewBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: GnomeColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: GnomeColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      
      // List tiles
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: accentColor.withOpacity(0.1),
      ),
      
      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: GnomeColors.sidebarBg,
        selectedColor: accentColor.withOpacity(0.2),
        labelStyle: TextStyle(color: GnomeColors.windowFg, fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
          side: BorderSide(color: GnomeColors.border),
        ),
      ),
      
      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: GnomeColors.dialogBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Bottom sheets
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: GnomeColors.popoverBg,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
      ),
      
      // Dividers
      dividerTheme: DividerThemeData(
        color: GnomeColors.shade,
        thickness: 1,
        space: 1,
      ),
      
      // Text theme
      textTheme: _buildTextTheme(GnomeColors.windowFg, GnomeColors.dim),
      
      // Icon theme
      iconTheme: IconThemeData(
        color: GnomeColors.windowFg,
        size: 24,
      ),
      
      // Floating action button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
  
  static ThemeData dark({
    GnomeAccent accent = GnomeAccent.blue,
    TargetPlatform? platform,
  }) {
    final accentColor = accent.darkColor;
    final colorScheme = ColorScheme.dark(
      primary: accentColor,
      onPrimary: Colors.black,
      secondary: accentColor,
      onSecondary: Colors.black,
      surface: GnomeColorsDark.windowBg,
      onSurface: GnomeColorsDark.windowFg,
      surfaceContainerHighest: GnomeColorsDark.sidebarBg,
      onSurfaceVariant: GnomeColorsDark.sidebarFg,
      error: GnomeColorsDark.error,
      onError: Colors.black,
      outline: GnomeColorsDark.border,
      shadow: Colors.black.withOpacity(0.3),
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      platform: platform,
      brightness: Brightness.dark,
      
      scaffoldBackgroundColor: GnomeColorsDark.windowBg,
      
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: GnomeColorsDark.headerBg,
        foregroundColor: GnomeColorsDark.headerFg,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(color: GnomeColorsDark.headerBorder),
        ),
        titleTextStyle: TextStyle(
          color: GnomeColorsDark.headerFg,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      cardTheme: CardThemeData(
        elevation: 0,
        color: GnomeColorsDark.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: GnomeColorsDark.cardShade),
        ),
        margin: EdgeInsets.zero,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: accentColor,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          minimumSize: const Size(0, 44),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: GnomeColorsDark.windowFg,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          side: BorderSide(color: GnomeColorsDark.border),
          minimumSize: const Size(0, 44),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          minimumSize: const Size(0, 44),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GnomeColorsDark.viewBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: GnomeColorsDark.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: GnomeColorsDark.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: accentColor.withOpacity(0.2),
      ),
      
      chipTheme: ChipThemeData(
        backgroundColor: GnomeColorsDark.sidebarBg,
        selectedColor: accentColor.withOpacity(0.3),
        labelStyle: TextStyle(color: GnomeColorsDark.windowFg, fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
          side: BorderSide(color: GnomeColorsDark.border),
        ),
      ),
      
      dialogTheme: DialogThemeData(
        backgroundColor: GnomeColorsDark.dialogBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: GnomeColorsDark.popoverBg,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
      ),
      
      dividerTheme: DividerThemeData(
        color: GnomeColorsDark.shade,
        thickness: 1,
        space: 1,
      ),
      
      textTheme: _buildTextTheme(GnomeColorsDark.windowFg, GnomeColorsDark.dim),
      
      iconTheme: IconThemeData(
        color: GnomeColorsDark.windowFg,
        size: 24,
      ),
      
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
  
  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: TextStyle(
        color: primary,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        color: primary,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        color: primary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      headlineLarge: TextStyle(
        color: primary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: primary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: primary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: primary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        color: primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: secondary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: primary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: primary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        color: secondary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        color: primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        color: primary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: secondary,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }
}
