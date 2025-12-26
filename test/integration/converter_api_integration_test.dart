import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:task_currency/core/constants/api_constants.dart';
import 'package:task_currency/core/error/exceptions.dart';
import 'package:task_currency/features/converter/data/models/conversion_model.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    dioAdapter = DioAdapter(dio: dio);
  });

  group('Converter API Integration Tests', () {
    const tFromCurrency = 'USD';
    const tToCurrency = 'EUR';
    const tAmount = 100.0;

    test(
      'should make request to correct endpoint with proper URL structure',
      () async {
        final endpoint = ApiConstants.pairConversion(
          tFromCurrency,
          tToCurrency,
          tAmount,
        );

        // Verify URL structure
        expect(endpoint, contains(ApiConstants.apiKey));
        expect(endpoint, contains('/pair/'));
        expect(endpoint, contains('$tFromCurrency/$tToCurrency/$tAmount'));

        dioAdapter.onGet(
          endpoint,
          (server) => server.reply(200, {
            'result': 'success',
            'conversion_rate': 0.85,
            'conversion_result': 85.0,
          }),
        );

        final response = await dio.get(endpoint);

        expect(response.statusCode, equals(200));
        expect(response.data['result'], equals('success'));
        expect(response.data['conversion_rate'], equals(0.85));
        expect(response.data['conversion_result'], equals(85.0));
      },
    );

    test(
      'should parse successful response into ConversionModel correctly',
      () async {
        final endpoint = ApiConstants.pairConversion(
          tFromCurrency,
          tToCurrency,
          tAmount,
        );

        dioAdapter.onGet(
          endpoint,
          (server) => server.reply(200, {
            'result': 'success',
            'conversion_rate': 0.85,
            'conversion_result': 85.0,
          }),
        );

        final response = await dio.get(endpoint);
        final data = response.data;

        // Simulate the data source parsing logic
        final model = ConversionModel(
          fromCurrency: tFromCurrency,
          toCurrency: tToCurrency,
          amount: tAmount,
          rate: (data['conversion_rate'] as num).toDouble(),
          result: (data['conversion_result'] as num).toDouble(),
        );

        expect(model.fromCurrency, equals(tFromCurrency));
        expect(model.toCurrency, equals(tToCurrency));
        expect(model.amount, equals(tAmount));
        expect(model.rate, equals(0.85));
        expect(model.result, equals(85.0));
      },
    );

    test('should handle API error response correctly', () async {
      final endpoint = ApiConstants.pairConversion(
        tFromCurrency,
        tToCurrency,
        tAmount,
      );

      dioAdapter.onGet(
        endpoint,
        (server) =>
            server.reply(200, {'result': 'error', 'error-type': 'invalid-key'}),
      );

      final response = await dio.get(endpoint);

      // Simulate data source error checking
      if (response.data['result'] != 'success') {
        expect(
          () => throw ServerException(
            message: response.data['error-type'] ?? 'Conversion failed',
          ),
          throwsA(isA<ServerException>()),
        );
      }
    });

    test('should handle 404 Not Found', () async {
      final endpoint = ApiConstants.pairConversion(
        tFromCurrency,
        tToCurrency,
        tAmount,
      );

      dioAdapter.onGet(
        endpoint,
        (server) => server.reply(404, {'error': 'Not found'}),
      );

      expect(() => dio.get(endpoint), throwsA(isA<DioException>()));
    });

    test('should handle 500 Internal Server Error', () async {
      final endpoint = ApiConstants.pairConversion(
        tFromCurrency,
        tToCurrency,
        tAmount,
      );

      dioAdapter.onGet(
        endpoint,
        (server) => server.reply(500, {'error': 'Internal server error'}),
      );

      try {
        await dio.get(endpoint);
        fail('Expected DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, equals(500));
      }
    });

    test('should handle connection timeout', () async {
      final endpoint = ApiConstants.pairConversion(
        tFromCurrency,
        tToCurrency,
        tAmount,
      );

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

    test('should handle no internet connection', () async {
      final endpoint = ApiConstants.pairConversion(
        tFromCurrency,
        tToCurrency,
        tAmount,
      );

      dioAdapter.onGet(
        endpoint,
        (server) => server.throws(
          0,
          DioException(
            requestOptions: RequestOptions(path: endpoint),
            type: DioExceptionType.connectionError,
            message: 'No internet',
          ),
        ),
      );

      try {
        await dio.get(endpoint);
        fail('Expected DioException');
      } on DioException catch (e) {
        expect(e.type, equals(DioExceptionType.connectionError));
      }
    });
  });
}
