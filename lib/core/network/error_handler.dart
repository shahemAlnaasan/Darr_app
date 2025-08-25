import 'dart:io';

import 'package:dio/dio.dart';

import 'exceptions.dart';

class ExceptionHandler {
  static Failure handleException(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    } else if (error is SocketException) {
      return const NetworkFailure(message: "خطأ بالاتصال، يرجى المحاولة مجددًا");
    } else {
      return Failure(message: error.toString());
    }
  }

  // ignore_for_file: body_might_complete_normally

  static Failure _handleDioException(DioException error) {
    // Handle connection-related errors first
    if (error.type == DioExceptionType.connectionError || error.error is SocketException)
      return const NetworkFailure(message: "خطأ بالاتصال، يرجى المحاولة مجددًا");

    // Handle specific error types
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure(message: "خطأ بالاتصال، يرجى المحاولة مجددًا");
      case DioExceptionType.cancel:
        return const NetworkFailure(message: "خطأ بالاتصال، يرجى المحاولة مجددًا");
      case DioExceptionType.badResponse:
        return _mapErrorToFailure(error.response!);
      case DioExceptionType.badCertificate:
        return const NetworkFailure(message: "خطأ بالاتصال، يرجى المحاولة مجددًا");
      case DioExceptionType.unknown:
        return NetworkFailure(
          message: _sanitizeErrorMessage(error.message ?? "خطأ بالاتصال، يرجى المحاولة مجددًا"),
          statusCode: error.response?.statusCode,
        );
    }
  }

  static Failure _mapErrorToFailure(Response response) {
    // Handle HTML responses (common with VPNs/proxies)
    if (_isHtmlResponse(response)) return const NetworkFailure(message: "خطأ بالاتصال، يرجى المحاولة مجددًا");

    // Handle empty responses
    if (response.data == null) return ServerFailure(message: 'Empty Server Response', statusCode: response.statusCode);

    // Extract error message from common JSON structures
    final dynamic data = response.data;
    final String message = _extractErrorMessage(data);

    // Handle specific status codes
    switch (response.statusCode) {
      case 400:
        return BadRequestFailure(message: message, statusCode: 400);
      case 401:
        return UnauthenticatedFailure(message: message, statusCode: 401);
      case 403:
        return ForbiddenFailure(message: message, statusCode: 403);
      case 404:
        return NotFoundFailure(message: message, statusCode: 404);
      case 429:
        return RateLimitFailure(message: message, statusCode: 429);
      case 500:
        return ServerFailure(message: message, statusCode: 500);
      case 502:
      case 503:
      case 504:
        return ServerFailure(message: message, statusCode: response.statusCode);
      default:
        return ServerFailure(message: message, statusCode: response.statusCode ?? 500);
    }
  }

  static bool _isHtmlResponse(Response response) {
    final contentType = response.headers['content-type']?.first.toLowerCase();
    return (response.data is String && (response.data as String).contains('<!DOCTYPE html>')) ||
        (contentType?.contains('text/html') == true);
  }

  static String _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] ?? data['error'] ?? data['errors']?.toString() ?? 'Unknown Error';
    }
    return data.toString();
  }

  static String _sanitizeErrorMessage(String message) {
    const sensitiveKeywords = ['password', 'token', 'secret', 'authorization'];

    for (final keyword in sensitiveKeywords) {
      if (message.toLowerCase().contains(keyword)) {
        return 'Authentication Error';
      }
    }
    return message;
  }
}
