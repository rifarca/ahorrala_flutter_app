import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._(); // Private constructor to prevent instantiation

  // ═══════════════════════════════════════════════════════════════════════════
  // 📏 SPACING SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════
  // Consistent spacing creates visual rhythm and hierarchy

  /// Extra small spacing (4px) - For tight layouts, borders
  static const double spacingXS = 4;

  /// Small spacing (8px) - For compact elements, form fields
  static const double spacingSM = 8;

  /// Medium spacing (16px) - For cards, buttons, general content
  static const double spacingMD = 16;

  /// Large spacing (24px) - For sections, major components
  static const double spacingLG = 24;

  /// Extra large spacing (32px) - For screen sections, headers
  static const double spacingXL = 32;

  /// Double extra large spacing (48px) - For major layout breaks
  static const double spacingXXL = 48;

  // ═══════════════════════════════════════════════════════════════════════════
  // 🔄 BORDER RADIUS SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════
  // Consistent corner rounding for modern, cohesive design

  /// Extra small radius (4px) - For subtle rounding, checkboxes
  static const double radiusXS = 4;

  /// Small radius (8px) - For buttons, chips, form fields
  static const double radiusSM = 8;

  /// Medium radius (12px) - For cards, containers
  static const double radiusMD = 12;

  /// Large radius (16px) - For prominent elements, dialogs
  static const double radiusLG = 16;

  /// Extra large radius (24px) - For hero elements, bottom sheets
  static const double radiusXL = 24;

  /// Full radius (9999px) - For circular elements, pills
  static const double radiusFull = 9999;

  // ═══════════════════════════════════════════════════════════════════════════
  // 🔲 BORDER WIDTH SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════
  // Consistent border widths for outlines and dividers

  /// Thin border (1px) - For subtle outlines, dividers
  static const double borderWidthThin = 1.0;

  /// Medium border (2px) - For form fields, buttons
  static const double borderWidthMedium = 2.0;

  /// Thick border (4px) - For emphasis, focus states
  static const double borderWidthThick = 4.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // 🏔️ ELEVATION SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════
  // Material Design elevation levels for depth hierarchy

  /// No elevation (0dp) - For flat elements on background
  static const double elevationLevel0 = 0;

  /// No elevation (0dp) - For flat elements on background
  static const double elevationLevel01 = 0.1;

  static const double elevationLevel02 = 0.2;

  static const double elevationLevel03 = 0.3;

  /// Level 1 elevation (1dp) - For cards, buttons at rest
  static const double elevationLevel1 = 1;

  /// Level 2 elevation (3dp) - For raised buttons, switches
  static const double elevationLevel2 = 3;

  /// Level 3 elevation (6dp) - For floating action buttons
  static const double elevationLevel3 = 6;

  /// Level 4 elevation (8dp) - For navigation drawer, modal bottom sheets
  static const double elevationLevel4 = 8;

  /// Level 5 elevation (12dp) - For app bar, dialogs
  static const double elevationLevel5 = 12;

  // ═══════════════════════════════════════════════════════════════════════════
  // ⚡ ANIMATION SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════
  // Consistent timing for smooth, professional animations

  /// Fast animation (150ms) - For micro-interactions, hover states
  static const Duration durationFast = Duration(milliseconds: 150);

  /// Normal animation (300ms) - For standard transitions, page changes
  static const Duration durationNormal = Duration(milliseconds: 300);

  /// Slow animation (500ms) - For complex animations, loading states
  static const Duration durationSlow = Duration(milliseconds: 500);

  // ═══════════════════════════════════════════════════════════════════════════
  // 📈 ANIMATION CURVES
  // ═══════════════════════════════════════════════════════════════════════════
  // Predefined curves for natural motion

  /// Default curve - Standard ease in/out for most animations
  static const Curve curveDefault = Curves.easeInOut;

  /// Emphasized curve - More dramatic easing for important transitions
  static const Curve curveEmphasized = Curves.easeInOutCubicEmphasized;

  /// Bounce curve - Playful bouncing effect for delightful interactions
  static const Curve curveBounce = Curves.bounceOut;

  /// Linear curve - Constant speed for loading indicators
  static const Curve curveLinear = Curves.linear;

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎯 COMMON MEASUREMENTS
  // ═══════════════════════════════════════════════════════════════════════════
  // Frequently used measurements for consistent implementation

  /// Standard button height (48px) - Meets accessibility guidelines
  static const double buttonHeight = 48.0;

  /// Large button height (56px) - For prominent actions
  static const double buttonHeightLarge = 56.0;

  /// Small button height (40px) - For compact layouts
  static const double buttonHeightSmall = 40.0;

  /// Text field height (56px) - Standard Material Design height
  static const double textFieldHeight = 56.0;

  /// App bar height (56px) - Standard Material Design app bar
  static const double appBarHeight = 56.0;

  /// App bar height (56px) - Standard Material Design app bar
  static const double appBarHeightMD = 70;

  /// Tab bar height (48px) - Standard Material Design tab bar
  static const double tabBarHeight = 48.0;

  /// Bottom navigation height (80px) - With padding and content
  static const double bottomNavHeight = 80.0;

  /// FAB size (56px) - Standard floating action button
  static const double fabSize = 56.0;

  /// Large FAB size (64px) - Extended floating action button
  static const double fabSizeLarge = 64.0;

  /// Avatar size (40px) - Standard user avatar
  static const double avatarSize = 40.0;

  /// Large avatar size (64px) - Profile or prominent display
  static const double avatarSizeLarge = 64.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // 📱 RESPONSIVE BREAKPOINTS
  // ═══════════════════════════════════════════════════════════════════════════
  // Screen size breakpoints for responsive design

  /// Mobile breakpoint (600px) - Phone screens
  /// Note: Breakpoints use raw logical pixels (not ScreenUtil-scaled) for correct responsive checks
  static const double breakpointMobile = 600.0;

  /// Tablet breakpoint (900px) - Tablet screens
  static const double breakpointTablet = 900.0;

  /// Desktop breakpoint (1200px) - Desktop screens
  static const double breakpointDesktop = 1200.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // 🔤 TYPOGRAPHY SCALE
  // ═══════════════════════════════════════════════════════════════════════════
  // Font sizes following Material Design 3 type scale

  /// Display Large (57px) - Hero text, major headlines
  static const double fontSizeDisplayLarge = 57.0;

  /// Display Medium (45px) - Large headers
  static const double fontSizeDisplayMedium = 45.0;

  /// Display Small (36px) - Section headers
  static const double fontSizeDisplaySmall = 36.0;

  /// Headline Large (32px) - Page titles
  static const double fontSizeHeadlineLarge = 32.0;

  /// Headline Medium (28px) - Card titles
  static const double fontSizeHeadlineMedium = 28.0;

  /// Headline Small (24px) - List headers
  static const double fontSizeHeadlineSmall = 24.0;

  /// Title Large (22px) - App bar titles
  static const double fontSizeTitleLarge = 22.0;

  /// Title Medium (16px) - Button text, tab labels
  static const double fontSizeTitleMedium = 16.0;

  /// Title Small (14px) - List item titles
  static const double fontSizeTitleSmall = 14.0;

  /// Body Large (16px) - Prominent body text
  static const double fontSizeBodyLarge = 16.0;

  /// Body Medium (14px) - Standard body text
  static const double fontSizeBodyMedium = 14.0;

  /// Body Small (12px) - Supporting text
  static const double fontSizeBodySmall = 12.0;

  /// Label Large (14px) - Form labels
  static const double fontSizeLabelLarge = 14.0;

  /// Label Medium (12px) - Caption text
  static const double fontSizeLabelMedium = 12.0;

  /// Label Small (11px) - Small annotations
  static const double fontSizeLabelSmall = 11.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎨 HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get responsive padding based on screen width
  static EdgeInsets getResponsivePadding(double screenWidth) {
    if (screenWidth >= breakpointDesktop) {
      return EdgeInsets.all(spacingXXL);
    } else if (screenWidth >= breakpointTablet) {
      return EdgeInsets.all(spacingXL);
    } else {
      return EdgeInsets.all(spacingMD);
    }
  }

  /// Get responsive text size multiplier
  static double getTextSizeMultiplier(double screenWidth) {
    if (screenWidth >= breakpointDesktop) {
      return 1.1; // 10% larger on desktop
    } else if (screenWidth >= breakpointTablet) {
      return 1.05; // 5% larger on tablet
    } else {
      return 1.0; // Standard size on mobile
    }
  }

  /// Check if screen is mobile size
  static bool isMobile(double screenWidth) => screenWidth < breakpointMobile;

  /// Check if screen is tablet size
  static bool isTablet(double screenWidth) =>
      screenWidth >= breakpointMobile && screenWidth < breakpointDesktop;

  /// Check if screen is desktop size
  static bool isDesktop(double screenWidth) => screenWidth >= breakpointDesktop;
}

/// AhorralaTheme provides light and dark theme configurations with Material 3 support
/// Generated with Flutter Theme Generator - Clean, modular, and maintainable
///
/// Features:
/// ✅ Uses AppConstants for consistent design tokens
/// ✅ Modular structure with separate theme components
/// ✅ Material 3 compliant color schemes
/// ✅ Support for 6 contrast modes (light, dark, medium/high contrast variants)
/// ✅ Production-ready with proper type declarations
class AhorralaTheme {
  AhorralaTheme._(); // Private constructor to prevent instantiation

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🎨 PUBLIC THEME GETTERS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Light theme configuration
  static ThemeData get lightTheme => theme(lightScheme());

  /// Dark theme configuration
  static ThemeData get darkTheme => theme(darkScheme());

  /// Light medium contrast theme
  static ThemeData get lightMediumContrast =>
      theme(lightMediumContrastScheme());

  /// Light high contrast theme
  static ThemeData get lightHighContrast => theme(lightHighContrastScheme());

  /// Dark medium contrast theme
  static ThemeData get darkMediumContrast => theme(darkMediumContrastScheme());

  /// Dark high contrast theme
  static ThemeData get darkHighContrast => theme(darkHighContrastScheme());

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🌈 COLOR SCHEMES - Material 3 compliant
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Light color scheme
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF10B981),
      surfaceTint: Color(0xFFFFFFFF),
      onPrimary: Color.fromARGB(255, 5, 16, 64),
      primaryContainer: Color.fromARGB(255, 255, 255, 255),
      onPrimaryContainer: Color(0xFF3b3ec9),
      secondary: Color.fromARGB(255, 40, 97, 149),
      onSecondary: Color(0xFF000000),
      secondaryContainer: Color.fromARGB(255, 46, 66, 86),
      onSecondaryContainer: Color.fromARGB(255, 218, 218, 221),
      tertiary: Color.fromARGB(255, 175, 232, 213),
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFF60ffd1),
      onTertiaryContainer: Color(0xFF009159),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color.fromARGB(255, 255, 255, 255),
      onErrorContainer: Color(0xFF93000A),
      surface: Color.fromARGB(255, 255, 255, 255),

      onSurface: Color.fromARGB(255, 45, 44, 50),
      onSurfaceVariant: Color.fromARGB(153, 176, 170, 186),
      outline: Color.fromARGB(255, 126, 122, 122),    
        outlineVariant: Color.fromARGB(255, 255, 255, 255),
      shadow: Color.fromARGB(255, 137, 156, 169),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF313033),
      onInverseSurface: Color.fromARGB(255, 255, 255, 255),
      inversePrimary: Color(0xFF4f52dd),
      primaryFixed: Color(0xFFb3b6ff),
      onPrimaryFixed: Color(0xFF272ab5),
      primaryFixedDim: Color(0xFF9fa2ff),
      onPrimaryFixedVariant: Color(0xFF4f52dd),
      secondaryFixed: Color(0xFFff98e9),
      onSecondaryFixed: Color(0xFFb00c5d),
      secondaryFixedDim: Color(0xFFff84d5),
      onSecondaryFixedVariant: Color(0xFFd83485),
      tertiaryFixed: Color(0xFF60ffd1),
      onTertiaryFixed: Color(0xFF007d45),
      tertiaryFixedDim: Color(0xFF4cf5bd),
      onTertiaryFixedVariant: Color(0xFF00a56d),
      surfaceDim: Color.fromARGB(0, 237, 252, 230),
      surfaceBright: Color.fromARGB(255, 255, 255, 255),
      surfaceContainerLowest: Color.fromARGB(255, 255, 255, 255),
      surfaceContainerLow: Color.fromARGB(255, 255, 255, 255),
      surfaceContainer: Color.fromARGB(255, 255, 255, 255),
      surfaceContainerHigh: Color.fromARGB(255, 255, 255, 255),
      surfaceContainerHighest: Color.fromARGB(255, 255, 255, 255),
    );
  }

  /// Dark color scheme
  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color.fromARGB(255, 26, 173, 82),
      surfaceTint: Color.fromARGB(255, 181, 235, 202),
      onPrimary: Color.fromARGB(255, 209, 211, 209),
      primaryContainer: Color.fromARGB(255, 26, 173, 82),
      onPrimaryContainer: Color.fromRGBO(255, 255, 255, 1),
      secondary: Color.fromARGB(255, 26, 173, 82),
      onSecondary: Color(0xFF000000),
      secondaryContainer: Color(0xFFb00c5d),
      onSecondaryContainer: Color(0xFFFFFFFF),
      tertiary: Color(0xFF00a56d),
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFF007d45),
      onTertiaryContainer: Color(0xFFFFFFFF),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF000000),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFFFFF),
      surface: Color.fromARGB(255, 3, 3, 3),
      onSurface: Color(0xFFE6E0E9),
      onSurfaceVariant: Color.fromARGB(255, 244, 240, 247),
      outline: Color(0xFF938F99),
      outlineVariant: Color(0xFF49454F),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE6E0E9),
      onInverseSurface: Color.fromARGB(255, 24, 24, 24),
      inversePrimary: Color.fromARGB(147, 52, 51, 51),
      primaryFixed: Color(0xFFb3b6ff),
      onPrimaryFixed: Color.fromARGB(255, 26, 173, 82),
      primaryFixedDim: Color(0xFF9fa2ff),
      onPrimaryFixedVariant: Color(0xFF4f52dd),
      secondaryFixed: Color(0xFFff98e9),
      onSecondaryFixed: Color(0xFFb00c5d),
      secondaryFixedDim: Color(0xFFff84d5),
      onSecondaryFixedVariant: Color.fromARGB(255, 174, 235, 197),
      tertiaryFixed: Color(0xFF60ffd1),
      onTertiaryFixed: Color(0xFF007d45),
      tertiaryFixedDim: Color(0xFF4cf5bd),
      onTertiaryFixedVariant: Color(0xFF00a56d),
      surfaceDim: Color.fromARGB(255, 12, 12, 12),
      surfaceBright: Color.fromARGB(255, 12, 12, 12),
      surfaceContainerLowest: Color.fromARGB(255, 18, 18, 18),
      surfaceContainerLow: Color.fromARGB(255, 12, 12, 12),
      surfaceContainer: Color.fromARGB(255, 12, 12, 12),
      surfaceContainerHigh: Color.fromARGB(255, 42, 41, 42),
      surfaceContainerHighest: Color.fromARGB(255, 12, 12, 12),
    );
  }

  /// Light medium contrast color scheme
  static ColorScheme lightMediumContrastScheme() {
    return lightScheme().copyWith(
      primary: Color.fromARGB(255, 91, 226, 84),
      surface: Color(0xFFfaf6f9),
    );
  }

  /// Light high contrast color scheme
  static ColorScheme lightHighContrastScheme() {
    return lightScheme().copyWith(
      primary: Color(0xFF4548d3),
      surface: Color(0xFFf5f1f4),
      outline: const Color(0xff000000),
    );
  }

  /// Dark medium contrast color scheme
  static ColorScheme darkMediumContrastScheme() {
    return darkScheme().copyWith(
      primary: Color(0xFF5e61ec),
      surface: Color(0xFF150e12),
    );
  }

  /// Dark high contrast color scheme
  static ColorScheme darkHighContrastScheme() {
    return darkScheme().copyWith(
      primary: Color(0xFF6d70fb),
      surface: Color.fromARGB(255, 20, 20, 20),
      outline: const Color(0xffffffff),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🎯 MAIN THEME BUILDER - Clean and modular structure
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Main theme function that combines all theme components
  /// Uses clean, modular structure with proper AppConstants integration
  static ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: _textTheme,
    appBarTheme: colorScheme.brightness == Brightness.light
        ? _lightAppBarTheme
        : _darkAppBarTheme,
    elevatedButtonTheme: elevatedButtonTheme(colorScheme),
    filledButtonTheme: filledButtonTheme(colorScheme),
    textButtonTheme: textButtonTheme(colorScheme),
    outlinedButtonTheme: outlinedButtonTheme(colorScheme),
    iconButtonTheme: iconButtonTheme(colorScheme),
    inputDecorationTheme: _inputDecorationTheme,
    cardTheme: _cardTheme,
    chipTheme: _chipTheme,
    progressIndicatorTheme: _progressIndicatorTheme,
    dividerTheme: _dividerTheme,
    bottomNavigationBarTheme: _bottomNavigationBarTheme,
    tabBarTheme: _tabBarTheme,
    switchTheme: switchTheme(colorScheme),
    checkboxTheme: _checkboxTheme,
    radioTheme: _radioTheme,
    sliderTheme: _sliderTheme,
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🎨 THEME COMPONENTS - All using AppConstants for consistency
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Text theme using AppConstants for consistent font sizes
  static final TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: AppConstants.fontSizeDisplayLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
    ),
    displayMedium: TextStyle(
      fontSize: AppConstants.fontSizeDisplayMedium,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
    ),
    displaySmall: TextStyle(
      fontSize: AppConstants.fontSizeDisplaySmall,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
    ),
    headlineLarge: TextStyle(
      fontSize: AppConstants.fontSizeHeadlineLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      fontSize: AppConstants.fontSizeHeadlineMedium,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.29,
    ),
    headlineSmall: TextStyle(
      fontSize: AppConstants.fontSizeHeadlineSmall,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.33,
    ),
    titleLarge: TextStyle(
      fontSize: AppConstants.fontSizeTitleLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.27,
    ),
    titleMedium: TextStyle(
      fontSize: AppConstants.fontSizeTitleMedium,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.50,
    ),
    titleSmall: TextStyle(
      fontSize: AppConstants.fontSizeTitleSmall,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    labelLarge: TextStyle(
      fontSize: AppConstants.fontSizeLabelLarge,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    labelMedium: TextStyle(
      fontSize: AppConstants.fontSizeLabelMedium,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
    ),
    labelSmall: TextStyle(
      fontSize: AppConstants.fontSizeLabelSmall,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
    ),
    bodyLarge: TextStyle(
      fontSize: AppConstants.fontSizeBodyLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      height: 1.50,
    ),
    bodyMedium: TextStyle(
      fontSize: AppConstants.fontSizeBodyMedium,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
    ),
    bodySmall: TextStyle(
      fontSize: AppConstants.fontSizeBodySmall,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
    ),
  );

  /// Elevated button theme - M3 compliant with WidgetStateProperty
  static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return 0;
            if (states.contains(WidgetState.hovered)) {
              return AppConstants.elevationLevel3;
            }
            if (states.contains(WidgetState.pressed)) {
              return AppConstants.elevationLevel02;
            }
            return AppConstants.elevationLevel2;
          }),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLG,
              vertical: AppConstants.spacingMD,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            ),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.12);
            }
            return colorScheme.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return colorScheme.onPrimary;
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.onPrimary.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.onPrimary.withValues(alpha: 0.08);
            }
            if (states.contains(WidgetState.focused)) {
              return colorScheme.onPrimary.withValues(alpha: 0.1);
            }
            return null;
          }),
          shadowColor: WidgetStateProperty.all(colorScheme.shadow),
        ),
      );

  /// Filled button theme - M3 compliant with WidgetStateProperty
  static FilledButtonThemeData filledButtonTheme(ColorScheme colorScheme) =>
      FilledButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLG,
              vertical: AppConstants.spacingMD,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            ),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.12);
            }
            return colorScheme.secondaryContainer;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return colorScheme.onSecondaryContainer;
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.onSecondaryContainer.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.onSecondaryContainer.withValues(alpha: 0.08);
            }
            return null;
          }),
        ),
      );

  /// Text button theme - M3 compliant with WidgetStateProperty
  static TextButtonThemeData textButtonTheme(ColorScheme colorScheme) =>
      TextButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLG,
              vertical: AppConstants.spacingMD,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            ),
          ),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return colorScheme.primary;
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.primary.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primary.withValues(alpha: 0.08);
            }
            if (states.contains(WidgetState.focused)) {
              return colorScheme.primary.withValues(alpha: 0.1);
            }
            return null;
          }),
        ),
      );

  /// Outlined button theme - M3 compliant with WidgetStateProperty
  static OutlinedButtonThemeData outlinedButtonTheme(ColorScheme colorScheme) =>
      OutlinedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLG,
              vertical: AppConstants.spacingMD,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            ),
          ),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(
                color: colorScheme.onSurface.withValues(alpha: 0.12),
              );
            }
            if (states.contains(WidgetState.focused)) {
              return BorderSide(color: colorScheme.primary);
            }
            return BorderSide(color: colorScheme.outline);
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return colorScheme.primary;
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.primary.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primary.withValues(alpha: 0.08);
            }
            return null;
          }),
        ),
      );

  /// Icon button theme - M3 compliant with WidgetStateProperty
  static IconButtonThemeData iconButtonTheme(ColorScheme colorScheme) =>
      IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return colorScheme.onSurfaceVariant;
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.onSurfaceVariant.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.onSurfaceVariant.withValues(alpha: 0.08);
            }
            return null;
          }),
        ),
      );

  /// Input decoration theme
  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMD,
          vertical: AppConstants.spacingMD,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
      );

  /// App bar theme for light mode
  static final AppBarTheme _lightAppBarTheme = AppBarTheme(
    elevation: AppConstants.elevationLevel02,
    centerTitle: true,
    titleSpacing: AppConstants.spacingMD,
    scrolledUnderElevation: AppConstants.elevationLevel02,
  );

  /// App bar theme for dark mode
  static final AppBarTheme _darkAppBarTheme = AppBarTheme(
    elevation: AppConstants.elevationLevel02,
    centerTitle: true,
    titleSpacing: AppConstants.spacingMD,
    scrolledUnderElevation: AppConstants.elevationLevel02,
  );

  /// Card theme
  static final CardThemeData _cardTheme = CardThemeData(
    elevation: AppConstants.elevationLevel02,
    margin: EdgeInsets.all(AppConstants.spacingSM),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusLG),
    ),
  );

  /// Chip theme
  static final ChipThemeData _chipTheme = ChipThemeData(
    padding: EdgeInsets.symmetric(
      horizontal: AppConstants.spacingMD,
      vertical: AppConstants.spacingSM,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusFull),
    ),
  );

  /// Progress indicator theme
  static final ProgressIndicatorThemeData _progressIndicatorTheme =
      ProgressIndicatorThemeData();

  /// Divider theme
  static final DividerThemeData _dividerTheme = DividerThemeData(
    thickness: AppConstants.borderWidthThin,
    space: AppConstants.spacingMD,
  );

  /// Bottom navigation bar theme
  static final BottomNavigationBarThemeData _bottomNavigationBarTheme =
      BottomNavigationBarThemeData(type: BottomNavigationBarType.fixed);

  /// Tab bar theme
  static final TabBarThemeData _tabBarTheme = TabBarThemeData(
    labelPadding: EdgeInsets.symmetric(
      horizontal: AppConstants.spacingMD,
      vertical: AppConstants.spacingSM,
    ),
  );

  /// Switch theme - uses colorScheme from theme() parameter
  static SwitchThemeData switchTheme(ColorScheme colorScheme) =>
      SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primaryContainer;
          }
          return null;
        }),
      );

  /// Checkbox theme
  static final CheckboxThemeData _checkboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusXS),
    ),
  );

  /// Radio theme
  static final RadioThemeData _radioTheme = RadioThemeData();

  /// Slider theme
  static final SliderThemeData _sliderTheme = SliderThemeData();
}

/// Custom theme colors extension for additional brand colors
extension CustomColors on ColorScheme {
  /// Success color for positive actions and states
  Color get success => const Color(0xFF2E7D32);

  /// Warning color for caution states
  Color get warning => const Color(0xFFF57C00);

  /// Info color for informational states
  Color get info => const Color(0xFF1976D2);
}
