import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late final SharedPreferences _prefs;

  // Keys
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userDataKey = 'user_data';
  static const String _themeKey = 'app_theme';
  static const String _languageKey = 'app_language';
  static const String _isFirstRunKey = 'is_first_run';
  static const String _notificationsEnabledKey = 'notifications_enabled';

  // Initialize shared preferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Authentication methods
  Future<bool> setToken(String token) async {
    return await _prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  Future<bool> setRefreshToken(String token) async {
    return await _prefs.setString(_refreshTokenKey, token);
  }

  Future<String?> getRefreshToken() async {
    return _prefs.getString(_refreshTokenKey);
  }

  Future<bool> clearTokens() async {
    await _prefs.remove(_tokenKey);
    return await _prefs.remove(_refreshTokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // User data methods
  Future<bool> setUserId(String userId) async {
    return await _prefs.setString(_userIdKey, userId);
  }

  Future<String?> getUserId() async {
    return _prefs.getString(_userIdKey);
  }

  Future<bool> setUserData(Map<String, dynamic> userData) async {
    final jsonString = jsonEncode(userData);
    return await _prefs.setString(_userDataKey, jsonString);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final jsonString = _prefs.getString(_userDataKey);
    if (jsonString != null) {
      try {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<bool> clearUserData() async {
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userDataKey);
    return await clearTokens();
  }

  // App settings methods
  Future<bool> setThemeMode(String theme) async {
    return await _prefs.setString(_themeKey, theme);
  }

  Future<String?> getThemeMode() async {
    return _prefs.getString(_themeKey);
  }

  Future<bool> setLanguage(String language) async {
    return await _prefs.setString(_languageKey, language);
  }

  Future<String?> getLanguage() async {
    return _prefs.getString(_languageKey);
  }

  Future<bool> saveLanguage(String language) async {
    return await _prefs.setString(_languageKey, language);
  }

  Future<bool> setIsFirstRun(bool isFirstRun) async {
    return await _prefs.setBool(_isFirstRunKey, isFirstRun);
  }

  Future<bool> isFirstRun() async {
    return _prefs.getBool(_isFirstRunKey) ?? true; // Default is true
  }

  Future<bool> setNotificationsEnabled(bool enabled) async {
    return await _prefs.setBool(_notificationsEnabledKey, enabled);
  }

  Future<bool> getNotificationsEnabled() async {
    return _prefs.getBool(_notificationsEnabledKey) ?? true; // Default is true
  }

  // Generic methods for storing data
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs.clear();
  }
}
