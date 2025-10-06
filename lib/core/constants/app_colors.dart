import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF4E73DF);
  static const Color primaryLight = Color(0xFFE3E6FF);
  static const Color primaryDark = Color(0xFF2E59D9);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF858796);
  static const Color secondaryLight = Color(0xFFF8F9FC);
  
  // Success Colors
  static const Color success = Color(0xFF1CC88A);
  static const Color successLight = Color(0xFFD1F2E9);
  
  // Info Colors
  static const Color info = Color(0xFF36B9CC);
  static const Color infoLight = Color(0xFFD1ECF1);
  
  // Warning Colors
  static const Color warning = Color(0xFFF6C23E);
  static const Color warningLight = Color(0xFFFFF3CD);
  
  // Danger Colors
  static const Color danger = Color(0xFFE74A3B);
  static const Color dangerLight = Color(0xFFF8D7DA);
  
  // Grayscale
  static const Color gray100 = Color(0xFFF8F9FC);
  static const Color gray200 = Color(0xFFE3E6F0);
  static const Color gray300 = Color(0xFFDDDFEB);
  static const Color gray400 = Color(0xFFD1D3E2);
  static const Color gray500 = Color(0xFFB7B9CC);
  static const Color gray600 = Color(0xFF858796);
  static const Color gray700 = Color(0xFF6E707E);
  static const Color gray800 = Color(0xFF5A5C69);
  static const Color gray900 = Color(0xFF3A3B45);
  
  // Basic Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textTertiary = Color(0xFFA0AEC0);
  
  // Background Colors
  static const Color background = Color(0xFFF8F9FC);
  static const Color surface = Colors.white;
  
  // Border Colors
  static const Color border = Color(0xFFE2E8F0);
  
  // Social Colors
  static const Color facebook = Color(0xFF3B5998);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color google = Color(0xFFDB4437);
  static const Color linkedin = Color(0xFF0077B5);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4E73DF), Color(0xFF224ABE)],
  );
  
  // Shadow Colors
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 10,
    offset: Offset(0, 4),
  );
}
