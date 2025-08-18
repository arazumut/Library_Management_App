import '../../../core/network/api_service.dart';
import '../../../core/services/storage_service.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthService({
    required ApiService apiService,
    required StorageService storageService,
  }) : _apiService = apiService,
       _storageService = storageService;

  // Kullanıcı giriş yapma
  Future<UserModel> login(String username, String password) async {
    try {
      // Django API'ye login isteği gönder
      final response = await _apiService.login(username, password);

      if (response['access'] == null) {
        throw Exception('JWT Access Token bulunamadı');
      }

      // Kullanıcı bilgilerini al
      final userResponse = await _apiService.getUserProfile();
      final user = UserModel.fromJson(userResponse);

      // Kullanıcı bilgilerini local storage'da sakla
      await _storageService.setUserData(user.toJson());

      return user;
    } catch (e) {
      throw Exception('Giriş yapılamadı: ${e.toString()}');
    }
  }

  // Kullanıcı çıkış yapma
  Future<void> logout() async {
    try {
      await _apiService.logout();
      await _storageService.clearUserData();
    } catch (e) {
      // Logout hatası olsa bile local data'yı temizle
      await _storageService.clearUserData();
      throw Exception('Çıkış yapılamadı: ${e.toString()}');
    }
  }

  // Token kontrolü - kullanıcının oturum açık mı?
  Future<bool> isLoggedIn() async {
    try {
      final token = await _storageService.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Kaydedilen kullanıcı bilgilerini al
  Future<UserModel?> getCurrentUser() async {
    try {
      final userData = await _storageService.getUserData();
      if (userData != null) {
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Kullanıcı bilgilerini refresh et
  Future<UserModel> refreshUserData() async {
    try {
      final userResponse = await _apiService.getUserProfile();
      final user = UserModel.fromJson(userResponse);

      // Güncellenmiş kullanıcı bilgilerini sakla
      await _storageService.setUserData(user.toJson());

      return user;
    } catch (e) {
      throw Exception('Kullanıcı bilgileri yenilenemedi: ${e.toString()}');
    }
  }

  // Token geçerliliğini kontrol et
  Future<bool> validateToken() async {
    try {
      // API'den kullanıcı profilini al - token geçersizse 401 hatası alırız
      await _apiService.getUserProfile();
      return true;
    } catch (e) {
      // Token geçersiz, logout yap
      await logout();
      return false;
    }
  }

  // Auto-login kontrolü (uygulama başlarken)
  Future<UserModel?> checkAutoLogin() async {
    try {
      if (await isLoggedIn()) {
        // Token geçerli mi kontrol et
        if (await validateToken()) {
          return await getCurrentUser();
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
