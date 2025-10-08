import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeUtils {
  // Text styles
  static TextStyle getTitleStyle(BuildContext context) {
    final theme = Theme.of(context);
    return GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: theme.textTheme.titleLarge?.color ?? Colors.black87,
    );
  }

  static TextStyle getBodyStyle(BuildContext context) {
    final theme = Theme.of(context);
    return GoogleFonts.inter(
      fontSize: 16,
      color: theme.textTheme.bodyLarge?.color ?? Colors.black87,
    );
  }

  static TextStyle getCaptionStyle(BuildContext context) {
    final theme = Theme.of(context);
    return GoogleFonts.inter(
      fontSize: 14,
      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.grey[600],
    );
  }

  // Card decoration
  static BoxDecoration getCardDecoration(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: theme.dividerColor.withOpacity(0.5),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // App bar style
  static AppBarTheme getAppBarTheme(ThemeData theme) {
    return AppBarTheme(
      backgroundColor: theme.brightness == Brightness.light 
          ? Colors.white 
          : theme.scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: theme.brightness == Brightness.light 
            ? Colors.black87 
            : Colors.white,
      ),
      iconTheme: IconThemeData(
        color: theme.brightness == Brightness.light 
            ? Colors.black87 
            : Colors.white,
      ),
    );
  }
}
