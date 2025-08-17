import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/core/theme/app_colors.dart';

class AppTextStyles {
  // Headings
  static TextStyle headline1 = GoogleFonts.poppins(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static TextStyle headline2 = GoogleFonts.poppins(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static TextStyle headline3 = GoogleFonts.poppins(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static TextStyle headline4 = GoogleFonts.poppins(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  // Body Text
  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  
  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  
  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  
  // Button Text
  static TextStyle buttonLarge = GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );
  
  static TextStyle buttonMedium = GoogleFonts.poppins(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );
  
  static TextStyle buttonSmall = GoogleFonts.poppins(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );
  
  // Caption and Overline
  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  
  static TextStyle overline = GoogleFonts.poppins(
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    color: AppColors.textSecondary,
  );
}
