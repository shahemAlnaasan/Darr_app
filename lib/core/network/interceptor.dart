import 'dart:developer';

import 'package:dio/dio.dart';
import '../../common/consts/app_keys.dart';
import '../datasources/hive_helper.dart';

import 'exceptions.dart';

class AppDioInterceptor extends Interceptor {
  AppDioInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await HiveHelper.getFromHive(boxName: AppKeys.userBox, key: AppKeys.tokenKey);

      if (token != null) {
        log("token sent $token");
        options.headers['X-Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      handler.reject(DioException(requestOptions: options, error: e));
      return;
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if ((response.data is String && response.data.contains('<!DOCTYPE html>')) ||
        (response.data is String && response.data.contains('<html>')) ||
        (response.data is String && response.data.contains('<html lang="ar">')) ||
        (response.data is String && response.data.contains('html') && response.data.contains('href')) ||
        (response.headers['content-type']?.first == 'text/html')) {
      throw const NetworkFailure(message: "خطأ بالاتصال، يرجى المحاولة مجددًا");
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
