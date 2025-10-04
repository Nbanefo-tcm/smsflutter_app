import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

// Text style constants for better maintainability
const double _displayLargeSize = 28.0;
const double _displayMediumSize = 24.0;
const double _titleLargeSize = 20.0;
const double _titleMediumSize = 18.0;
const double _bodyLargeSize = 16.0;
const double _bodyMediumSize = 14.0;
const double _labelLargeSize = 16.0;
const double _letterSpacing = 0.5;

/// Extension methods for [ThemeData] to provide custom theme configurations.
extension ThemeDataX on ThemeData {
  // Get text theme with custom font
  static TextTheme get _textTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();
    return baseTextTheme.copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: _displayLargeSize,
        fontWeight: FontWeight.bold,
        letterSpacing: _letterSpacing,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: _displayMediumSize,
        fontWeight: FontWeight.bold,
        letterSpacing: _letterSpacing,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: _titleLargeSize,
        fontWeight: FontWeight.w600,
        letterSpacing: _letterSpacing,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: _titleMediumSize,
        fontWeight: FontWeight.w600,
        letterSpacing: _letterSpacing * 0.5,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: _bodyLargeSize,
        height: 1.5,
        letterSpacing: _letterSpacing * 0.25,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: _bodyMediumSize,
        height: 1.5,
        letterSpacing: _letterSpacing * 0.25,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: _labelLargeSize,
        fontWeight: FontWeight.w600,
        letterSpacing: _letterSpacing * 0.5,
      ),
    );
  }
}

class AppTheme {
  /// Creates a light theme configuration.
  /// 
  /// This theme uses the Material 3 design system with a light color scheme
  /// and custom typography based on the Inter font family.
  static ThemeData get lightTheme {
    final baseTheme = ThemeData.light(useMaterial3: true);
    
    return baseTheme.copyWith(
      colorScheme: ColorScheme.light(
        // Primary colors
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        
        // Secondary colors
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        
        // Error colors
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        
        // Surface colors (replaces deprecated background/onBackground)
        surface: AppColors.lightSurface1,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.lightSurface2,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        surfaceTint: AppColors.surfaceTint,
        // Surface variants for elevation overlays
        surfaceContainerLowest: AppColors.lightSurface3,
        
        // Outline colors
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        
        // Other
        shadow: AppColors.shadow,
        scrim: AppColors.scrim,
      ),
      scaffoldBackgroundColor: AppColors.background,
      // Card Theme is defined below after all other theme properties
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.onSurface,
          size: 24,
        ),
        titleTextStyle: ThemeDataX._textTheme.titleLarge?.copyWith(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.borderRadiusSmall),
          ),
          textStyle: ThemeDataX._textTheme.labelLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: ThemeDataX._textTheme.labelLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.borderRadiusSmall),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.borderRadiusSmall),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.borderRadiusSmall),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: AppColors.textSecondary),
        hintStyle: GoogleFonts.inter(color: AppColors.textTertiary),
      ),
      // Text Theme
      textTheme: ThemeDataX._textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
        decorationColor: AppColors.textPrimary,
      ),
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        labelStyle: ThemeDataX._textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
        secondaryLabelStyle: ThemeDataX._textTheme.bodyMedium?.copyWith(
          color: AppColors.onPrimary,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
      ),
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        indent: 16,
        endIndent: 16,
      ),
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surface,
        shadowColor: AppColors.shadow,
        surfaceTintColor: AppColors.surfaceTint,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Creates a dark theme configuration.
  /// 
  /// This theme uses the Material 3 design system with a dark color scheme
  /// and custom typography based on the Inter font family.
  static ThemeData get darkTheme {
    final baseTheme = ThemeData.dark(useMaterial3: true);
    
    return baseTheme.copyWith(
      colorScheme: ColorScheme.dark(
        // Primary colors
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        
        // Secondary colors
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        
        // Error colors
        error: AppColors.darkError,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        
        // Surface colors (replaces deprecated background/onBackground)
        surface: AppColors.darkSurface1,
        onSurface: AppColors.darkOnSurface,
        surfaceContainerHighest: AppColors.darkSurface2,
        onSurfaceVariant: AppColors.darkOnSurfaceVariant,
        surfaceTint: AppColors.surfaceTint,
        // Surface variants for elevation overlays
        surfaceContainerLowest: AppColors.darkSurface4,
        
        // Outline colors
        outline: AppColors.darkBorder,
        outlineVariant: AppColors.darkBorder,
        
        // Other
        shadow: AppColors.shadow,
        scrim: AppColors.scrim,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.darkSurface1,
        shadowColor: AppColors.shadow,
        surfaceTintColor: AppColors.surfaceTint,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.borderRadiusMedium),
          side: const BorderSide(
            color: AppColors.darkBorder,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(16),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: const BorderSide(color: AppColors.accent),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: AppColors.darkTextSecondary),
        hintStyle: GoogleFonts.inter(color: AppColors.darkTextTertiary),
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.darkTextPrimary,
          letterSpacing: 0.5,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.darkTextPrimary,
          letterSpacing: 0.5,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: AppColors.darkTextSecondary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.darkTextTertiary,
          height: 1.5,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        labelStyle: GoogleFonts.inter(color: AppColors.darkTextSecondary),
        secondaryLabelStyle: GoogleFonts.inter(color: AppColors.onPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
