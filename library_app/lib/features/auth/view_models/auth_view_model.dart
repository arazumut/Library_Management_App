import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus {
  initial,
  authenticating,
  authenticated,
  unauthenticated,
  error,
}

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;

  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  UserModel? _currentUser;

  AuthViewModel(this._authService) {
    _checkAuthStatus();
  }

  // Getters
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    try {
      final user = await _authService.checkAutoLogin();

      if (user != null) {
        _status = AuthStatus.authenticated;
        _currentUser = user;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  // Login method - Django API username kullanıyor
  Future<bool> login({
    required String username, // Email yerine username
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      _status = AuthStatus.authenticating;
      _errorMessage = null;
      notifyListeners();

      // Django API'ye gerçek login isteği
      final user = await _authService.login(username, password);

      _status = AuthStatus.authenticated;
      _currentUser = user;

      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Register method - Django API'de register endpoint'i yok, manuel eklenmeli
  Future<bool> register({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      _status = AuthStatus.authenticating;
      _errorMessage = null;
      notifyListeners();

      // Django API'de register endpoint'i yoksa manuel kullanıcı eklenmeli
      // Şimdilik hata döndürelim
      throw Exception(
        'Kayıt işlemi henüz desteklenmiyor. Lütfen admin ile iletişime geçin.',
      );
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      await _authService.logout();

      _status = AuthStatus.unauthenticated;
      _currentUser = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Refresh user profile
  Future<void> refreshUserProfile() async {
    try {
      final user = await _authService.refreshUserData();
      _currentUser = user;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Password reset request - Django API'de şimdilik desteklenmiyor
  Future<bool> requestPasswordReset(String email) async {
    try {
      _errorMessage = null;
      notifyListeners();

      // Django API'de password reset endpoint'i yoksa manuel yapılmalı
      throw Exception(
        'Şifre sıfırlama henüz desteklenmiyor. Lütfen admin ile iletişime geçin.',
      );
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    String? email,
    String? profileImageUrl,
  }) async {
    try {
      _errorMessage = null;
      notifyListeners();

      // Django API'de profile update endpoint'i eklenene kadar simüle et
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          firstName: firstName,
          lastName: lastName,
          email: email ?? _currentUser!.email,
          profileImageUrl: profileImageUrl ?? _currentUser!.profileImageUrl,
        );
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
