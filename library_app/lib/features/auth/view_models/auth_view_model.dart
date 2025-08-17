import 'package:flutter/material.dart';
import 'package:library_app/core/network/api_service.dart';
import 'package:library_app/core/services/storage_service.dart';
import 'package:library_app/features/auth/models/user_model.dart';

enum AuthStatus {
  initial,
  authenticating,
  authenticated,
  unauthenticated,
  error,
}

class AuthViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;
  
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  UserModel? _currentUser;
  
  AuthViewModel(this._apiService, this._storageService) {
    _checkAuthStatus();
  }
  
  // Getters
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  
  // Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    final token = await _storageService.getToken();
    
    if (token != null && token.isNotEmpty) {
      _status = AuthStatus.authenticated;
      await _fetchUserProfile();
    } else {
      _status = AuthStatus.unauthenticated;
    }
    
    notifyListeners();
  }
  
  // Login method
  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      _status = AuthStatus.authenticating;
      _errorMessage = null;
      notifyListeners();
      
      // Simulated API call for login
      // In a real app, you would use _apiService.post('login', data: {...})
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
      
      // Simulating successful login
      if (email == 'test@example.com' && password == 'password123') {
        final token = 'simulated_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
        final refreshToken = 'simulated_refresh_token_${DateTime.now().millisecondsSinceEpoch}';
        
        await _storageService.setToken(token);
        await _storageService.setRefreshToken(refreshToken);
        
        // Save user ID for profile fetching
        await _storageService.setUserId('1');
        
        _status = AuthStatus.authenticated;
        
        // Create a simulated user
        _currentUser = UserModel(
          id: '1',
          name: 'Test User',
          email: email,
          role: 'reader',
          profileImageUrl: null,
        );
        
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = 'Invalid email or password';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Register method
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _status = AuthStatus.authenticating;
      _errorMessage = null;
      notifyListeners();
      
      // Simulated API call for registration
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
      
      // Simulating successful registration
      final token = 'simulated_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
      final refreshToken = 'simulated_refresh_token_${DateTime.now().millisecondsSinceEpoch}';
      
      await _storageService.setToken(token);
      await _storageService.setRefreshToken(refreshToken);
      
      // Save user ID for profile fetching
      await _storageService.setUserId('2');
      
      _status = AuthStatus.authenticated;
      
      // Create a simulated user
      _currentUser = UserModel(
        id: '2',
        name: name,
        email: email,
        role: 'reader',
        profileImageUrl: null,
      );
      
      notifyListeners();
      return true;
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
      // Clear stored tokens
      await _storageService.clearTokens();
      await _storageService.clearUserData();
      
      _status = AuthStatus.unauthenticated;
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  // Fetch user profile
  Future<void> _fetchUserProfile() async {
    try {
      final userId = await _storageService.getUserId();
      
      if (userId == null) {
        throw Exception('User ID not found');
      }
      
      // Simulated API call to get user profile
      // In a real app: final response = await _apiService.get('users/profile');
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      // Simulated user data
      _currentUser = UserModel(
        id: userId,
        name: 'Test User',
        email: 'test@example.com',
        role: 'reader',
        profileImageUrl: null,
      );
      
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  // Password reset request
  Future<bool> requestPasswordReset(String email) async {
    try {
      _errorMessage = null;
      notifyListeners();
      
      // Simulated API call for password reset
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
      
      // Always return success in demo
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Update user profile
  Future<bool> updateProfile({
    required String name,
    String? profileImageUrl,
  }) async {
    try {
      _errorMessage = null;
      notifyListeners();
      
      // Simulated API call to update profile
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      // Update the current user
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          name: name,
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
}
