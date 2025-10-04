import 'package:flutter/material.dart';

/// A collection of colors used throughout the application.
/// 
/// This class provides a centralized way to manage all colors used in the app,
/// ensuring consistency and making it easier to implement theming.
/// 
/// Colors are organized into logical groups with clear naming conventions:
/// - Base colors (white, black, transparent)
/// - Primary colors (primary, onPrimary, etc.)
/// - Secondary colors
/// - Error colors
/// - Success colors
/// - Warning colors
/// - Info colors
/// - Text colors (for light/dark themes)
/// - Surface/background colors
/// - Border/outline colors
/// - Elevation/shadows
/// - State layer colors
class AppColors {
  // Base Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;
  
  // Primary Colors
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0x1A2563EB);
  static const Color primaryContainer = Color(0xFFE0E7FF);
  static const Color onPrimary = white;
  static const Color onPrimaryContainer = Color(0xFF001A41);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color onSecondary = white;
  static const Color secondaryContainer = Color(0xFFEDE9FE);
  static const Color onSecondaryContainer = Color(0xFF1E0061);

  // Error Colors
  static const Color error = Color(0xFFEF4444);
  static const Color onError = white;
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);
  static const Color darkError = Color(0xFFFFB4AB);

  // Success Colors
  static const Color success = Color(0xFF10B981);
  static const Color onSuccess = white;
  static const Color successContainer = Color(0xFFD1FAE5);
  
  // Warning Colors
  static const Color warning = Color(0xFFF59E0B);
  static const Color onWarning = black;
  static const Color warningContainer = Color(0xFFFEF3C7);
  
  // Info Colors
  static const Color info = Color(0xFF3B82F6);
  static const Color onInfo = white;
  static const Color infoContainer = Color(0xFFDBEAFE);

  // Text Colors - Light Theme
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF94A3B8);
  static const Color textOnPrimary = white;
  static const Color textOnAccent = Color(0xFF082F49);
  
  // Background & Surface - Light Theme
  static const Color background = white;
  static const Color surface = Color(0xFFF8FAFC);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color onBackground = textPrimary;
  static const Color onSurface = textPrimary;
  static const Color onSurfaceVariant = textSecondary;
  static const Color surfaceTint = Color(0x0A000000);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkSurfaceContainerHighest = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextTertiary = Color(0xFF94A3B8);
  static const Color darkOnSurface = Color(0xFFE2E8F0);
  static const Color darkOnSurfaceVariant = Color(0xFFCBD5E1);
  static const Color darkBorder = Color(0xFF475569);
  
  // Surface colors for dark theme
  static const Color darkSurface1 = Color(0xFF1E293B);
  static const Color darkSurface2 = Color(0xFF1F2937);
  static const Color darkSurface3 = Color(0xFF1E1E1E);
  static const Color darkSurface4 = Color(0xFF2D2D2D);
  
  // Surface colors for light theme
  static const Color lightSurface1 = Color(0xFFFFFFFF);
  static const Color lightSurface2 = Color(0xFFF8FAFC);
  static const Color lightSurface3 = Color(0xFFF1F5F9);
  static const Color lightSurface4 = Color(0xFFE2E8F0);
  
  // Accent Color
  static const Color accent = Color(0xFF8B5CF6);
  
  // Border Colors
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color borderDark = Color(0xFFCBD5E1);
  static const Color outline = border;
  static const Color outlineVariant = Color(0xFFE5E7EB);
  
  // Elevation & Shadows
  static const Color shadow = Color(0x40000000);
  static const Color elevationOverlay = Color(0x0A000000);
  static const Color scrim = Color(0x99000000);
  
  // Disabled State
  static const Color disabled = Color(0xFF9CA3AF);
  static const Color onDisabled = Color(0xFF6B7280);
  
  // Border Radius
  static const double borderRadiusXSmall = 4.0;
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;
  static const double borderRadiusFull = 100.0;
  
  // Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double spacingXXLarge = 48.0;
  
  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;
  static const double elevationXLarge = 16.0;

  // Social Media Colors
  static const Color apple = Color(0xFF000000);
  static const Color twitter = Color(0xFF1DA1F2);
  
  // State Layer Colors
  static const Color hoverOverlay = Color(0x0A000000);
  static const Color pressedOverlay = Color(0x1F000000);
  
  // Other
  static const Color overlay = Color(0x99000000);
  static const Color disabledBackground = Color(0xFFF1F5F9);
}
