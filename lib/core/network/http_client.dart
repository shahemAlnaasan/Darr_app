import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import 'interceptor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@factoryMethod
abstract class HTTPClient {
  Future<Response> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    ResponseType? responseType,
    CancelToken? cancelToken,
  });

  Future<Response> post(String url, {Map<String, dynamic>? headers, dynamic data, CancelToken? cancelToken});

  Future<Response> put(String url, {Map<String, dynamic>? headers, dynamic data, CancelToken? cancelToken});

  Future<Response> delete(String url, {Map<String, dynamic>? headers, dynamic data, CancelToken? cancelToken});
}

@LazySingleton(as: HTTPClient)
class DioClient implements HTTPClient {
  final Dio dio;

  DioClient() : dio = _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        validateStatus: (status) => true,
      ),
    );
    dio.options.headers = {'Content-Type': 'application/json'};
    dio.interceptors.addAll([
      PrettyDioLogger(requestBody: true, responseBody: true, request: true, requestHeader: true, maxWidth: 60),
      AppDioInterceptor(),
    ]);

    return dio;
  }

  @override
  Future<Response> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    ResponseType? responseType,
    CancelToken? cancelToken,
  }) {
    return dio.get(
      url,
      options: Options(headers: headers, responseType: responseType),
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<Response> post(String url, {Map<String, dynamic>? headers, dynamic data, CancelToken? cancelToken}) async {
    // Only check for files if data is a Map
    if (data is Map<String, dynamic>) {
      bool hasFile = data.values.any(
        (value) => value is File || value is List<File> || value is XFile || value is List<XFile> || value is Uint8List,
      );

      if (hasFile) {
        final formData = FormData();

        for (var entry in data.entries) {
          final key = entry.key;
          final value = entry.value;

          if (value is File) {
            formData.files.add(
              MapEntry(key, await MultipartFile.fromFile(value.path, filename: value.path.split('/').last)),
            );
          } else if (value is List<File>) {
            for (var file in value) {
              formData.files.add(
                MapEntry(key, await MultipartFile.fromFile(file.path, filename: file.path.split('/').last)),
              );
            }
          } else if (value is XFile) {
            formData.files.add(MapEntry(key, await MultipartFile.fromFile(value.path, filename: value.name)));
          } else if (value is List<XFile>) {
            for (var file in value) {
              formData.files.add(MapEntry(key, await MultipartFile.fromFile(file.path, filename: file.name)));
            }
          } else if (value is Uint8List) {
            formData.files.add(MapEntry(key, MultipartFile.fromBytes(value, filename: 'uploaded_file')));
          } else {
            formData.fields.add(MapEntry(key, value.toString()));
          }
        }

        data = formData;
      }
    }

    return dio.post(url, data: data, options: Options(headers: headers), cancelToken: cancelToken);
  }

  @override
  Future<Response> put(String url, {Map<String, dynamic>? headers, dynamic data, CancelToken? cancelToken}) {
    return dio.put(url, data: data, options: Options(headers: headers), cancelToken: cancelToken);
  }

  @override
  Future<Response> delete(String url, {Map<String, dynamic>? headers, dynamic data, CancelToken? cancelToken}) {
    return dio.delete(url, data: data, options: Options(headers: headers), cancelToken: cancelToken);
  }
}
