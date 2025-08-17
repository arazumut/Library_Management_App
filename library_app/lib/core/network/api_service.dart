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
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Get token from storage
        final token = await _storageService.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
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
    ));
    
    // Add logging interceptor in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }
  
  // Generic GET request
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(
        path,
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
  
  // Generic POST request
  Future<dynamic> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
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
  Future<dynamic> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
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
  Future<dynamic> patch(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
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
  Future<dynamic> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
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
    String paramName, 
    {Map<String, dynamic>? data}
  ) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        paramName: await MultipartFile.fromFile(file.path, filename: fileName),
        ...?data,
      });
      
      final response = await _dio.post(
        path,
        data: formData,
      );
      return response.data;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }
  
  // Token refresh mechanism
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }
      
      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Authorization': null}), // Don't send the expired token
      );
      
      final newToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];
      
      // Save new tokens
      await _storageService.setToken(newToken);
      await _storageService.setRefreshToken(newRefreshToken);
      
      return true;
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
        'Authorization': 'Bearer $token',
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
}
