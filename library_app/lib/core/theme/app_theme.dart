import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textWhite,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.textWhite,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textWhite,
      secondaryContainer: AppColors.secondaryLight,
      onSecondaryContainer: AppColors.textWhite,
      tertiary: AppColors.info,
      error: AppColors.error,
      background: AppColors.background,
      onBackground: AppColors.textPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
    ),
    
    // Text Theme
    textTheme: TextTheme(
      displayLarge: AppTextStyles.headline1,
      displayMedium: AppTextStyles.headline2,
      displaySmall: AppTextStyles.headline3,
      headlineMedium: AppTextStyles.headline4,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.buttonLarge,
      labelMedium: AppTextStyles.buttonMedium,
      labelSmall: AppTextStyles.buttonSmall,
    ),
    
    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.headline3.copyWith(
        color: AppColors.textWhite,
      ),
    ),
    
    // Card Theme
    cardTheme: CardTheme(
      color: AppColors.surface,
      elevation: 2,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        textStyle: AppTextStyles.buttonMedium,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.buttonMedium,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.buttonMedium,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    
    // Input Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.textLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.textLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.error),
      ),
      labelStyle: AppTextStyles.bodyMedium,
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
      errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
    ),
    
    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      selectedLabelStyle: AppTextStyles.caption,
      unselectedLabelStyle: AppTextStyles.caption,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
  
  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.textWhite,
      primaryContainer: AppColors.primary,
      onPrimaryContainer: AppColors.textWhite,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.textWhite,
      secondaryContainer: AppColors.secondary,
      onSecondaryContainer: AppColors.textWhite,
      tertiary: AppColors.infoDark,
      error: AppColors.errorDark,
      background: AppColors.backgroundDark,
      onBackground: AppColors.textWhite,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textWhite,
      surfaceVariant: AppColors.cardDark,
      surfaceTint: AppColors.elevatedDark,
    ),
    
    // Text Theme
    textTheme: TextTheme(
      displayLarge: AppTextStyles.headline1.copyWith(color: AppColors.textWhite),
      displayMedium: AppTextStyles.headline2.copyWith(color: AppColors.textWhite),
      displaySmall: AppTextStyles.headline3.copyWith(color: AppColors.textWhite),
      headlineMedium: AppTextStyles.headline4.copyWith(color: AppColors.textWhite),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textWhite),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.textWhite),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.textLight),
      labelLarge: AppTextStyles.buttonLarge,
      labelMedium: AppTextStyles.buttonMedium,
      labelSmall: AppTextStyles.buttonSmall,
    ),
    
    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.cardDark,
      foregroundColor: AppColors.textWhite,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.headline3.copyWith(
        color: AppColors.textWhite,
      ),
      iconTheme: IconThemeData(
        color: AppColors.primaryLight,
      ),
    ),
    
    // Card Theme
    cardTheme: CardTheme(
      color: AppColors.cardDark,
      elevation: 4,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.textWhite,
        textStyle: AppTextStyles.buttonMedium,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        textStyle: AppTextStyles.buttonMedium,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: BorderSide(color: AppColors.primaryLight, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        textStyle: AppTextStyles.buttonMedium,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    
    // Input Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.elevatedDark,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.errorDark, width: 1.5),
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryLight),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
      errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.errorDark),
      prefixIconColor: AppColors.primaryLight,
      suffixIconColor: AppColors.primaryLight,
    ),
    
    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardDark,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.textLight,
      selectedLabelStyle: AppTextStyles.caption.copyWith(
        color: AppColors.primaryLight,
        fontWeight: FontWeight.w600
      ),
      unselectedLabelStyle: AppTextStyles.caption.copyWith(color: AppColors.textLight),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    
    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppColors.elevatedDark,
      thickness: 1,
      space: 1,
    ),
    
    // Dialog Theme
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.cardDark,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
