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

    final tHistoricalResponse = {
      'USD_KWD': {
        '2025-12-18': 0.306,
        '2025-12-19': 0.307,
        '2025-12-20': 0.308,
        '2025-12-21': 0.307,
        '2025-12-22': 0.306,
        '2025-12-23': 0.307,
        '2025-12-24': 0.308,
        '2025-12-25': 0.307,
      },
    };

    test('should return list of HistoricalRateModel when API call is successful', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => tHistoricalResponse);

      final result = await dataSource.getHistoricalRates(tFromCurrency, tToCurrency, tStartDate, tEndDate);

      expect(result, isA<List<HistoricalRateModel>>());
      expect(result.length, 8);
      verify(() => mockDioClient.get(any())).called(1);
    });

    test('should return rates sorted by date', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => tHistoricalResponse);

      final result = await dataSource.getHistoricalRates(tFromCurrency, tToCurrency, tStartDate, tEndDate);

      for (int i = 0; i < result.length - 1; i++) {
        expect(result[i].date.isBefore(result[i + 1].date), true);
      }
    });

    test('should throw ServerException when response is null', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => null);

      expect(() => dataSource.getHistoricalRates(tFromCurrency, tToCurrency, tStartDate, tEndDate), throwsA(isA<ServerException>()));
    });

    test('should throw ServerException when pair data is not available', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => {'OTHER_PAIR': {}});

      expect(() => dataSource.getHistoricalRates(tFromCurrency, tToCurrency, tStartDate, tEndDate), throwsA(isA<ServerException>()));
    });

    test('should correctly parse date and rate from response', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => tHistoricalResponse);

      final result = await dataSource.getHistoricalRates(tFromCurrency, tToCurrency, tStartDate, tEndDate);

      final firstRate = result.first;
      expect(firstRate.fromCurrency, tFromCurrency);
      expect(firstRate.toCurrency, tToCurrency);
      expect(firstRate.date, DateTime(2025, 12, 18));
      expect(firstRate.rate, 0.306);
    });
  });
}
