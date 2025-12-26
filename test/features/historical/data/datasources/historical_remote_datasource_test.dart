import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/constants/api_constants.dart';
import 'package:task_currency/core/error/exceptions.dart';
import 'package:task_currency/features/historical/data/datasources/historical_remote_datasource.dart';
import 'package:task_currency/features/historical/data/models/historical_rate_model.dart';

import '../../../../mocks.dart';

void main() {
  late HistoricalRemoteDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = HistoricalRemoteDataSourceImpl(mockDioClient);
  });

  group('HistoricalRemoteDataSourceImpl', () {
    const tFromCurrency = 'USD';
    const tToCurrency = 'KWD';
    final tStartDate = DateTime(2025, 1, 1);
    final tEndDate = DateTime(2025, 1, 7);

    final tSuccessResponse = {
      'result': 'success',
      'conversion_rates': {'KWD': 0.307, 'EUR': 0.85, 'GBP': 0.75},
    };

    group('getHistoricalRates', () {
      test(
        'should return list of HistoricalRateModel when API call succeeds',
        () async {
          when(
            () => mockDioClient.get(ApiConstants.latestRates(tFromCurrency)),
          ).thenAnswer((_) async => tSuccessResponse);

          final result = await dataSource.getHistoricalRates(
            tFromCurrency,
            tToCurrency,
            tStartDate,
            tEndDate,
          );

          expect(result, isA<List<HistoricalRateModel>>());
          expect(result.length, equals(7)); // 7 days of simulated data
          expect(result.first.fromCurrency, equals(tFromCurrency));
          expect(result.first.toCurrency, equals(tToCurrency));
        },
      );

      test(
        'should throw ServerException when API returns error result',
        () async {
          when(
            () => mockDioClient.get(ApiConstants.latestRates(tFromCurrency)),
          ).thenAnswer(
            (_) async => {'result': 'error', 'error-type': 'invalid-key'},
          );

          expect(
            () => dataSource.getHistoricalRates(
              tFromCurrency,
              tToCurrency,
              tStartDate,
              tEndDate,
            ),
            throwsA(isA<ServerException>()),
          );
        },
      );

      test('should throw ServerException when API returns null', () async {
        when(
          () => mockDioClient.get(ApiConstants.latestRates(tFromCurrency)),
        ).thenAnswer((_) async => null);

        expect(
          () => dataSource.getHistoricalRates(
            tFromCurrency,
            tToCurrency,
            tStartDate,
            tEndDate,
          ),
          throwsA(isA<ServerException>()),
        );
      });

      test(
        'should throw ServerException when target currency not found in rates',
        () async {
          when(
            () => mockDioClient.get(ApiConstants.latestRates(tFromCurrency)),
          ).thenAnswer(
            (_) async => {
              'result': 'success',
              'conversion_rates': {'EUR': 0.85, 'GBP': 0.75},
            },
          );

          expect(
            () => dataSource.getHistoricalRates(
              tFromCurrency,
              tToCurrency,
              tStartDate,
              tEndDate,
            ),
            throwsA(
              predicate<ServerException>(
                (e) => e.message == 'Currency $tToCurrency not found',
              ),
            ),
          );
        },
      );

      test(
        'should throw ServerException when conversion_rates is null',
        () async {
          when(
            () => mockDioClient.get(ApiConstants.latestRates(tFromCurrency)),
          ).thenAnswer(
            (_) async => {'result': 'success', 'conversion_rates': null},
          );

          expect(
            () => dataSource.getHistoricalRates(
              tFromCurrency,
              tToCurrency,
              tStartDate,
              tEndDate,
            ),
            throwsA(isA<ServerException>()),
          );
        },
      );
    });
  });
}
