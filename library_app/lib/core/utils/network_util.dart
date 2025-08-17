import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtil {
  static final Connectivity _connectivity = Connectivity();

  // Check if device has internet connection
  static Future<bool> hasInternetConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
  
  // Stream of connectivity changes
  static Stream<ConnectivityResult> get connectivityStream {
    return _connectivity.onConnectivityChanged;
  }
}
