class NetworkConfig {
  // Geliştirme ortamı ayarları
  static const bool isDevelopment = true;

  // Farklı platform API URL'leri
  static String get baseUrl {
    if (isDevelopment) {
      // Geliştirme için Django local server
      return _getLocalUrl();
    } else {
      // Production API URL (ileride eklenecek)
      return 'https://your-production-api.com/api';
    }
  }

  static String _getLocalUrl() {
    // Platform detection yapıp uygun URL döndür
    try {
      // Android Emülatör için
      return 'http://10.0.2.2:8000/api';
    } catch (e) {
      // Fallback
      return 'http://127.0.0.1:8000/api';
    }
  }

  // iOS Simulator için alternatif URL
  static String get iOSUrl => 'http://127.0.0.1:8000/api';

  // Fiziksel cihaz için IP (manuel güncellenmeli)
  static String get physicalDeviceUrl => 'http://192.168.1.100:8000/api';

  // Timeout ayarları
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // API test durumu kontrolü
  static bool isApiAvailable = false;

  // Test endpoint'i
  static String get testEndpoint => '/test/';
}

// Platform helper
class PlatformHelper {
  static bool get isAndroidEmulator {
    // Android emülatör detection logic
    return true; // Şimdilik default true
  }

  static bool get isIOSSimulator {
    // iOS simulator detection logic
    return false;
  }

  static bool get isPhysicalDevice {
    // Physical device detection logic
    return false;
  }
}
