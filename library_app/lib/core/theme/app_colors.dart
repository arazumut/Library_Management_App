import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF3949AB); // Indigo
  static const Color primaryLight = Color(0xFF6F74DD);
  static const Color primaryDark = Color(0xFF00227B);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF26A69A); // Teal
  static const Color secondaryLight = Color(0xFF64D8CB);
  static const Color secondaryDark = Color(0xFF00766C);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF252525);
  static const Color elevatedDark = Color(0xFF2C2C2C);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF2E7D32);
  static const Color error = Color(0xFFE53935);
  static const Color errorDark = Color(0xFFC62828);
  static const Color warning = Color(0xFFFFB300);
  static const Color warningDark = Color(0xFFFFA000);
  static const Color info = Color(0xFF2196F3);
  static const Color infoDark = Color(0xFF1976D2);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [backgroundDark, Color(0xFF1A1A1A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
