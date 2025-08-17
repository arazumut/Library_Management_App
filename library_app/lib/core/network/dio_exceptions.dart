import 'dart:io';
import 'package:dio/dio.dart';
import 'package:library_app/core/network/api_endpoints.dart';

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout with API server";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
        break;
      case DioExceptionType.connectionError:
        if (dioError.error is SocketException) {
          message = "No Internet Connection";
          break;
        }
        message = "Unexpected error occurred";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return error['message'] ?? 'Bad request';
      case 401:
        return error['message'] ?? 'Unauthorized';
      case 403:
        return error['message'] ?? 'Forbidden';
      case 404:
        return error['message'] ?? 'Not found';
      case 409:
        return error['message'] ?? 'Conflict';
      case 422:
        return error['message'] ?? 'Unprocessable Entity';
      case 500:
        return error['message'] ?? 'Internal server error';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
