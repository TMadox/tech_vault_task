import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../error/exceptions.dart';

@lazySingleton
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: AppConstants.apiTimeout,
        receiveTimeout: AppConstants.apiTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => log(obj.toString()),
      ),
    );
  }

  Future<dynamic> get(String url) async {
    try {
      final response = await _dio.get(url);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ServerException _handleDioError(DioException error) => switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => const ServerException(
      message: 'error.connection_timeout',
      statusCode: 408,
    ),
    DioExceptionType.badResponse => ServerException(
      message: error.response?.data?['error'] ?? 'error.server_error',
      statusCode: error.response?.statusCode,
    ),
    DioExceptionType.connectionError => const ServerException(
      message: 'error.no_internet',
      statusCode: 0,
    ),
    _ => ServerException(
      message: error.message ?? 'error.unknown_error',
      statusCode: error.response?.statusCode,
    ),
  };
}
