import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:library_app/core/network/api_endpoints.dart';
import 'package:library_app/core/network/dio_exceptions.dart';
import 'package:library_app/core/services/storage_service.dart';

class ApiService {
  final Dio _dio;
  final StorageService _storageService;

  ApiService(this._storageService) : _dio = Dio() {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get token from storage - Django Token Auth format
          final token = await _storageService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] =
                'Bearer $token'; // JWT Bearer format
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          // Handle token refresh if 401 error
          if (error.response?.statusCode == 401) {
            if (await _refreshToken()) {
              // Retry the request with the new token
              return handler.resolve(await _retry(error.requestOptions));
            }
          }
          return handler.next(error);
        },
      ),
    );

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  // Generic GET request
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // Generic POST request
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // Generic PUT request
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // Generic PATCH request
  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // Generic DELETE request
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // Upload file
  Future<dynamic> uploadFile(
    String path,
    File file,
    String paramName, {
    Map<String, dynamic>? data,
  }) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        paramName: await MultipartFile.fromFile(file.path, filename: fileName),
        ...?data,
      });

      final response = await _dio.post(path, data: formData);
      return response.data;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // Token refresh mechanism - Django API basit token auth kullanıyor, refresh yok
  Future<bool> _refreshToken() async {
    try {
      // Django'da basit token auth var, kullanıcının tekrar login olması gerekir
      await _storageService.clearTokens();
      return false;
    } catch (e) {
      // If refresh fails, clear tokens and return false
      await _storageService.clearTokens();
      return false;
    }
  }

  // Retry the original request with new token
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final token = await _storageService.getToken();
    final options = Options(
      method: requestOptions.method,
      headers: {
        'Authorization': 'Bearer $token', // JWT Bearer format
        ...requestOptions.headers,
      },
    );

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  // Django JWT Auth için login metodu
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['access'] != null) {
        await _storageService.setToken(
          responseData['access'],
        ); // JWT access token
        print('JWT Token saved: ${responseData['access']}');

        // Refresh token'ı da saklayabiliriz ileride
        if (responseData['refresh'] != null) {
          await _storageService.setUserData({
            'refresh_token': responseData['refresh'],
          });
          print('Refresh token saved');
        }
      }

      return responseData;
    } catch (e) {
      print('Login error: $e');
      throw e;
    }
  }

  // Kullanıcı profil bilgilerini alma
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await get(ApiEndpoints.userProfile);
      return response;
    } catch (e) {
      throw e;
    }
  }

  // Logout
  Future<void> logout() async {
    await _storageService.clearTokens();
  }
}
