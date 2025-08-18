import 'package:flutter/material.dart';
import 'package:library_app/core/constants/app_constants.dart';
import 'package:library_app/core/services/storage_service.dart';

class ThemeService extends ChangeNotifier {
  final StorageService _storageService;
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeService(this._storageService) {
    _loadThemeMode();
  }
  
  // Getter for the current theme mode
  ThemeMode get themeMode => _themeMode;
  
  // Check if the current theme is dark
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  // Load theme from storage
  Future<void> _loadThemeMode() async {
    final themeSetting = await _storageService.getThemeMode();
    if (themeSetting != null) {
      _themeMode = _getThemeMode(themeSetting);
    }
    notifyListeners();
  }
  
  // Convert string theme setting to ThemeMode enum
  ThemeMode _getThemeMode(String themeSetting) {
    switch (themeSetting) {
      case AppConstants.themeModeLight:
        return ThemeMode.light;
      case AppConstants.themeModeDark:
        return ThemeMode.dark;
      default:
        // Sistem temasını kullan
        return ThemeMode.system;
    }
  }
  
  // Set theme mode to light
  Future<void> setLightMode() async {
    _themeMode = ThemeMode.light;
    await _storageService.setThemeMode(AppConstants.themeModeLight);
    notifyListeners();
  }
  
  // Set theme mode to dark
  Future<void> setDarkMode() async {
    _themeMode = ThemeMode.dark;
    await _storageService.setThemeMode(AppConstants.themeModeDark);
    notifyListeners();
  }
  
  // Set theme mode to system default
  Future<void> setSystemMode() async {
    _themeMode = ThemeMode.system;
    await _storageService.setThemeMode(AppConstants.themeModeSystem);
    notifyListeners();
  }
  
  // Toggle between light and dark mode
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      await setLightMode();
    } else {
      await setDarkMode();
    }
  }
}
