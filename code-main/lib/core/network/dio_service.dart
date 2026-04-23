import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  static const String _baseUrl = 'https://beecodebackend.onrender.com/api';

  late final Dio dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..interceptors.addAll([
      _AuthInterceptor(),
      if (kDebugMode)
        LogInterceptor(
          requestBody:  true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (o) => debugPrint('[DIO] $o'),
        ),
    ]);
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────');
      debugPrint('│ 🚀 REQUEST');
      debugPrint('│ Method  : ${options.method}');
      debugPrint('│ URL     : ${options.baseUrl}${options.path}');
      debugPrint('│ Headers : ${options.headers}');
      debugPrint('│ Body    : ${options.data}');
      debugPrint('└─────────────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────');
      debugPrint('│ ✅ RESPONSE');
      debugPrint('│ Status  : ${response.statusCode}');
      debugPrint('│ URL     : ${response.requestOptions.path}');
      debugPrint('│ Data    : ${response.data}');
      debugPrint('└─────────────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────');
      debugPrint('│ ❌ ERROR');
      debugPrint('│ URL     : ${err.requestOptions.baseUrl}${err.requestOptions.path}');
      debugPrint('│ Status  : ${err.response?.statusCode}');
      debugPrint('│ Message : ${err.message}');
      debugPrint('│ Data    : ${err.response?.data}');
      debugPrint('└─────────────────────────────────────────');
    }
    handler.next(err);
  }
}