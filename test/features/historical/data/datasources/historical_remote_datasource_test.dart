import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/error/exceptions.dart';
import 'package:task_currency/core/network/dio_client.dart';
import 'package:task_currency/features/historical/data/datasources/historical_remote_datasource.dart';
import 'package:task_currency/features/historical/data/models/historical_rate_model.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late HistoricalRemoteDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = HistoricalRemoteDataSourceImpl(mockDioClient);
  });

  group('getHistoricalRates', () {
    const tFromCurrency = 'USD';
    const tToCurrency = 'KWD';
    final tStartDate = DateTime(2025, 12, 18);
    final tEndDate = DateTime(2025, 12, 25);

    final tLatestResponse = {
      'result': 'success',
      'base_code': 'USD',
      'conversion_rates': {'USD': 1.0, 'KWD': 0.307, 'EUR': 0.92},
    };

    test('should return list of HistoricalRateModel when API call is successful', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => tLatestResponse);

      final result = await dataSource.getHistoricalRates(tFromCurrency, tToCurrency, tStartDate, tEndDate);

      expect(result, isA<List<HistoricalRateModel>>());
      expect(result.length, 7);
      verify(() => mockDioClient.get(any())).called(1);
    });

    test('should return rates sorted by date', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => tLatestResponse);

      final result = await dataSource.getHistoricalRates(tFromCurrency, tToCurrency, tStartDate, tEndDate);

      for (int i = 0; i < result.length - 1; i++) {
        expect(result[i].date.isBefore(result[i + 1].date), true);
      }
    });

    test('should throw ServerException when response is null', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => null);

      expect(() => dataSource.getHistoricalRates(tFromCurrency, tToCurrency, tStartDate, tEndDate), throwsA(isA<ServerException>()));
    });

    test('should throw ServerException when target currency not found', () async {
      when(() => mockDioClient.get(any())).thenAnswer(
        (_) async => {
          'result': 'success',
          'conversion_rates': {'USD': 1.0},
        },
      );

      expect(() => dataSource.getHistoricalRates(tFromCurrency, tToCurrency, tStartDate, tEndDate), throwsA(isA<ServerException>()));
    });

    test('should return rates with correct currency codes', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => tLatestResponse);

      final result = await dataSource.getHistoricalRates(tFromCurrency, tToCurrency, tStartDate, tEndDate);

      for (final rate in result) {
        expect(rate.fromCurrency, tFromCurrency);
        expect(rate.toCurrency, tToCurrency);
      }
    });
  });
}
