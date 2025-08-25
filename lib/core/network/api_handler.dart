import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'error_handler.dart';
import 'exceptions.dart';

mixin ApiHandler {
  bool _isHttpSuccess(Response response) => [200, 201, 202].contains(response.statusCode);
  bool _isApiSuccess(dynamic data) {
    try {
      final status = data is String ? jsonDecode(data)["status"] : data["status"];
      final id = data is String ? jsonDecode(data)["id"] : data["id"];
      final result = status.toString() == "1" && id.toString() != "0";
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<Either<Failure, T>> handleApiCall<T>({
    required Future<Response> Function() apiCall,
    T Function(dynamic json)? fromJson,
    bool validateApi = true,
  }) async {
    try {
      final response = await apiCall();

      dynamic jsonData;

      try {
        jsonData = response.data is String ? jsonDecode(response.data) : response.data;
      } catch (e) {
        return Left(Failure(message: "خطأ في قراءة البيانات من السيرفر"));
      }

      final isHttpOk = _isHttpSuccess(response);
      final isApiOk = !validateApi || _isApiSuccess(jsonData);

      if (isHttpOk && isApiOk) {
        if (fromJson != null) {
          return Right(fromJson(jsonData));
        }
        if (T == Unit) return Right(unit as T);
        return Right(jsonData as T);
      }

      final message = jsonData["message"]?.toString() ?? "خطأ بالاتصال، يرجى المحاولة مجدداً";
      return Left(Failure(message: message));
    } catch (error) {
      if (error is DioException && error.response != null) {
        try {
          final json = error.response!.data is String ? jsonDecode(error.response!.data) : error.response!.data;
          final msg = json["message"]?.toString() ?? "خطأ غير متوقع";
          return Left(Failure(message: msg));
        } catch (_) {}
      }

      return Left(ExceptionHandler.handleException(error));
    }
  }

  Future<Either<Failure, T>> getFile<T>({required Future<Response> Function() apiCall}) async {
    try {
      final response = await apiCall();
      if (response.statusCode == 200) return Right(response.data as T);
      return Left(ExceptionHandler.handleException(response));
    } catch (error) {
      return Left(ExceptionHandler.handleException(error));
    }
  }
}
