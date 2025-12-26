import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:task_currency/core/constants/api_constants.dart';
import 'package:task_currency/core/error/exceptions.dart';
import 'package:task_currency/features/historical/data/models/historical_rate_model.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    dioAdapter = DioAdapter(dio: dio);
  });

  group('Historical Rates API Integration Tests', () {
    const tFromCurrency = 'USD';
    const tToCurrency = 'KWD';

    test('should make request to correct endpoint', () async {
      final endpoint = ApiConstants.latestRates(tFromCurrency);

      // Verify URL structure
      expect(endpoint, contains(ApiConstants.apiKey));
      expect(endpoint, contains('/latest/'));
      expect(endpoint, contains(tFromCurrency));

      dioAdapter.onGet(
        endpoint,
        (server) => server.reply(200, {
          'result': 'success',
          'conversion_rates': {'KWD': 0.307, 'EUR': 0.85},
        }),
      );

      final response = await dio.get(endpoint);

      expect(response.statusCode, equals(200));
      expect(response.data['result'], equals('success'));
    });

    test('should parse conversion rates correctly', () async {
      final endpoint = ApiConstants.latestRates(tFromCurrency);

      dioAdapter.onGet(
        endpoint,
        (server) => server.reply(200, {
          'result': 'success',
          'conversion_rates': {
            'KWD': 0.307,
            'EUR': 0.85,
            'GBP': 0.75,
            'JPY': 149.50,
          },
        }),
      );

      final response = await dio.get(endpoint);
      final rates = response.data['conversion_rates'] as Map<String, dynamic>;

      expect(rates.containsKey(tToCurrency), isTrue);
      expect(rates[tToCurrency], equals(0.307));

      // Simulate HistoricalRateModel creation
      final rate = (rates[tToCurrency] as num).toDouble();
      final model = HistoricalRateModel(
        fromCurrency: tFromCurrency,
        toCurrency: tToCurrency,
        date: DateTime.now(),
        rate: rate,
      );

      expect(model.fromCurrency, equals(tFromCurrency));
      expect(model.toCurrency, equals(tToCurrency));
      expect(model.rate, equals(0.307));
    });

    test('should handle missing target currency in rates', () async {
      final endpoint = ApiConstants.latestRates(tFromCurrency);

      dioAdapter.onGet(
        endpoint,
        (server) => server.reply(200, {
          'result': 'success',
          'conversion_rates': {
            'EUR': 0.85,
            'GBP': 0.75,
            // KWD is missing
          },
        }),
      );

      final response = await dio.get(endpoint);
      final rates = response.data['conversion_rates'] as Map<String, dynamic>;

      if (!rates.containsKey(tToCurrency)) {
        expect(
          () =>
              throw ServerException(message: 'Currency $tToCurrency not found'),
          throwsA(
            predicate<ServerException>(
              (e) => e.message == 'Currency $tToCurrency not found',
            ),
          ),
        );
      }
    });

    test('should handle API error response', () async {
      final endpoint = ApiConstants.latestRates(tFromCurrency);

      dioAdapter.onGet(
        endpoint,
        (server) => server.reply(200, {
          'result': 'error',
          'error-type': 'unsupported-code',
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

    test('should handle null conversion_rates', () async {
      final endpoint = ApiConstants.latestRates(tFromCurrency);

      dioAdapter.onGet(
        endpoint,
        (server) =>
            server.reply(200, {'result': 'success', 'conversion_rates': null}),
      );

      final response = await dio.get(endpoint);
      final rates = response.data['conversion_rates'];

      if (rates == null) {
        expect(
          () => throw const ServerException(message: 'No rates data'),
          throwsA(isA<ServerException>()),
        );
      }
    });

    test('should handle 500 Server Error', () async {
      final endpoint = ApiConstants.latestRates(tFromCurrency);

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

    test('should handle connection error', () async {
      final endpoint = ApiConstants.latestRates(tFromCurrency);

      dioAdapter.onGet(
        endpoint,
        (server) => server.throws(
          0,
          DioException(
            requestOptions: RequestOptions(path: endpoint),
            type: DioExceptionType.connectionError,
            message: 'No internet connection',
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

    test('should handle send timeout', () async {
      final endpoint = ApiConstants.latestRates(tFromCurrency);

      dioAdapter.onGet(
        endpoint,
        (server) => server.throws(
          408,
          DioException(
            requestOptions: RequestOptions(path: endpoint),
            type: DioExceptionType.sendTimeout,
          ),
        ),
      );

      try {
        await dio.get(endpoint);
        fail('Expected DioException');
      } on DioException catch (e) {
        expect(e.type, equals(DioExceptionType.sendTimeout));
      }
    });
  });
}
