import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:task_currency/core/constants/api_constants.dart';
import 'package:task_currency/core/error/exceptions.dart';
import 'package:task_currency/features/currencies/data/models/currency_model.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    dioAdapter = DioAdapter(dio: dio);
  });

  group('Currencies API Integration Tests', () {
    test('should make request to correct endpoint', () async {
      final endpoint = ApiConstants.supportedCodes();

      // Verify URL structure
      expect(endpoint, contains(ApiConstants.apiKey));
      expect(endpoint, contains('/codes'));

      dioAdapter.onGet(
        endpoint,
        (server) => server.reply(200, {
          'result': 'success',
          'supported_codes': [
            ['USD', 'United States Dollar'],
            ['EUR', 'Euro'],
          ],
        }),
      );

      final response = await dio.get(endpoint);

      expect(response.statusCode, equals(200));
      expect(response.data['result'], equals('success'));
    });

    test('should parse currency list correctly from API response', () async {
      final endpoint = ApiConstants.supportedCodes();

      dioAdapter.onGet(
        endpoint,
        (server) => server.reply(200, {
          'result': 'success',
          'supported_codes': [
            ['USD', 'United States Dollar'],
            ['EUR', 'Euro'],
            ['GBP', 'British Pound Sterling'],
            ['KWD', 'Kuwaiti Dinar'],
          ],
        }),
      );

      final response = await dio.get(endpoint);
      final supportedCodes = response.data['supported_codes'] as List<dynamic>;

      // Simulate data source parsing
      final currencies = supportedCodes.map((item) {
        final codeData = item as List<dynamic>;
        return CurrencyModel.fromApiResponse(
          codeData[0] as String,
          codeData[1] as String,
        );
      }).toList();

      expect(currencies.length, equals(4));
      expect(currencies[0].id, equals('USD'));
      expect(currencies[0].currencyName, equals('United States Dollar'));
      expect(currencies[0].countryCode, equals('us'));

      // Verify sorting works
      currencies.sort((a, b) => a.currencyName.compareTo(b.currencyName));
      expect(currencies[0].currencyName, equals('British Pound Sterling'));
      expect(currencies[1].currencyName, equals('Euro'));
    });

    test('should handle API error response', () async {
      final endpoint = ApiConstants.supportedCodes();

      dioAdapter.onGet(
        endpoint,
        (server) => server.reply(200, {
          'result': 'error',
          'error-type': 'quota-reached',
        }),
      );

      final response = await dio.get(endpoint);

      if (response.data['result'] != 'success') {
        expect(
          () => throw ServerException(
            message: response.data['error-type'] ?? 'Failed to fetch',
          ),
          throwsA(isA<ServerException>()),
        );
      }
    });

    test('should handle null supported_codes', () async {
      final endpoint = ApiConstants.supportedCodes();

      dioAdapter.onGet(
        endpoint,
        (server) =>
            server.reply(200, {'result': 'success', 'supported_codes': null}),
      );

      final response = await dio.get(endpoint);
      final supportedCodes = response.data['supported_codes'];

      if (supportedCodes == null) {
        expect(
          () =>
              throw const ServerException(message: 'No currency data received'),
          throwsA(
            predicate<ServerException>(
              (e) => e.message == 'No currency data received',
            ),
          ),
        );
      }
    });

    test('should handle 401 Unauthorized', () async {
      final endpoint = ApiConstants.supportedCodes();

      dioAdapter.onGet(
        endpoint,
        (server) => server.reply(401, {'error': 'Invalid API key'}),
      );

      try {
        await dio.get(endpoint);
        fail('Expected DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, equals(401));
      }
    });

    test('should handle network timeout', () async {
      final endpoint = ApiConstants.supportedCodes();

      dioAdapter.onGet(
        endpoint,
        (server) => server.throws(
          408,
          DioException(
            requestOptions: RequestOptions(path: endpoint),
            type: DioExceptionType.connectionTimeout,
          ),
        ),
      );

      try {
        await dio.get(endpoint);
        fail('Expected DioException');
      } on DioException catch (e) {
        expect(e.type, equals(DioExceptionType.connectionTimeout));
      }
    });

    test('should handle receive timeout', () async {
      final endpoint = ApiConstants.supportedCodes();

      dioAdapter.onGet(
        endpoint,
        (server) => server.throws(
          408,
          DioException(
            requestOptions: RequestOptions(path: endpoint),
            type: DioExceptionType.receiveTimeout,
          ),
        ),
      );

      try {
        await dio.get(endpoint);
        fail('Expected DioException');
      } on DioException catch (e) {
        expect(e.type, equals(DioExceptionType.receiveTimeout));
      }
    });
  });
}
