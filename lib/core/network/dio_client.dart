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
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, logPrint: (obj) => print(obj)));
  }

  Future<dynamic> get(String url) async {
    try {
      final response = await _dio.get(url);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ServerException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerException(message: 'Connection timeout. Please try again.', statusCode: 408);
      case DioExceptionType.badResponse:
        return ServerException(message: error.response?.data?['error'] ?? 'Server error occurred', statusCode: error.response?.statusCode);
      case DioExceptionType.connectionError:
        return const ServerException(message: 'No internet connection', statusCode: 0);
      default:
        return ServerException(message: error.message ?? 'Unknown error occurred', statusCode: error.response?.statusCode);
    }
  }
}
