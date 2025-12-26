import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/error/exceptions.dart';
import 'package:task_currency/core/error/failures.dart';
import 'package:task_currency/features/historical/data/models/historical_rate_model.dart';
import 'package:task_currency/features/historical/data/repositories/historical_repository_impl.dart';

import '../../../../mocks.dart';

void main() {
  late HistoricalRepositoryImpl repository;
  late MockHistoricalRemoteDataSource mockRemoteDataSource;
  late MockHistoricalLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockHistoricalRemoteDataSource();
    mockLocalDataSource = MockHistoricalLocalDataSource();
    repository = HistoricalRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
    );
  });

  setUpAll(() {
    registerFallbackValue(<HistoricalRateModel>[]);
  });

  group('HistoricalRepositoryImpl', () {
    const tFromCurrency = 'USD';
    const tToCurrency = 'KWD';
    final tStartDate = DateTime(2025, 1, 1);
    final tEndDate = DateTime(2025, 1, 7);

    final tHistoricalRateModels = [
      HistoricalRateModel(
        fromCurrency: tFromCurrency,
        toCurrency: tToCurrency,
        date: DateTime(2025, 1, 1),
        rate: 0.307,
      ),
      HistoricalRateModel(
        fromCurrency: tFromCurrency,
        toCurrency: tToCurrency,
        date: DateTime(2025, 1, 2),
        rate: 0.308,
      ),
    ];

    group('getHistoricalRates', () {
      test('should return cached rates when cache is valid', () async {
        when(
          () => mockLocalDataSource.hasCachedRates(
            tFromCurrency,
            tToCurrency,
            tStartDate,
            tEndDate,
          ),
        ).thenAnswer((_) async => true);
        when(
          () => mockLocalDataSource.getHistoricalRates(
            tFromCurrency,
            tToCurrency,
            tStartDate,
            tEndDate,
          ),
        ).thenAnswer((_) async => tHistoricalRateModels);

        final result = await repository.getHistoricalRates(
          tFromCurrency,
          tToCurrency,
          tStartDate,
          tEndDate,
        );

        expect(result, equals(Right(tHistoricalRateModels)));
        verify(
          () => mockLocalDataSource.hasCachedRates(
            tFromCurrency,
            tToCurrency,
            tStartDate,
            tEndDate,
          ),
        ).called(1);
        verify(
          () => mockLocalDataSource.getHistoricalRates(
            tFromCurrency,
            tToCurrency,
            tStartDate,
            tEndDate,
          ),
        ).called(1);
        verifyNever(
          () => mockRemoteDataSource.getHistoricalRates(
            any(),
            any(),
            any(),
            any(),
          ),
        );
      });

      test(
        'should fetch from remote and cache when no cached rates exist',
        () async {
          when(
            () => mockLocalDataSource.hasCachedRates(
              tFromCurrency,
              tToCurrency,
              tStartDate,
              tEndDate,
            ),
          ).thenAnswer((_) async => false);
          when(
            () => mockRemoteDataSource.getHistoricalRates(
              tFromCurrency,
              tToCurrency,
              tStartDate,
              tEndDate,
            ),
          ).thenAnswer((_) async => tHistoricalRateModels);
          when(
            () => mockLocalDataSource.cacheHistoricalRates(any()),
          ).thenAnswer((_) async {});

          final result = await repository.getHistoricalRates(
            tFromCurrency,
            tToCurrency,
            tStartDate,
            tEndDate,
          );

          expect(result, equals(Right(tHistoricalRateModels)));
          verify(
            () => mockRemoteDataSource.getHistoricalRates(
              tFromCurrency,
              tToCurrency,
              tStartDate,
              tEndDate,
            ),
          ).called(1);
          verify(
            () =>
                mockLocalDataSource.cacheHistoricalRates(tHistoricalRateModels),
          ).called(1);
        },
      );

      test(
        'should return cached rates when remote fails and cache is available',
        () async {
          when(
            () => mockLocalDataSource.hasCachedRates(
              tFromCurrency,
              tToCurrency,
              tStartDate,
              tEndDate,
            ),
          ).thenAnswer((_) async => false);
          when(
            () => mockRemoteDataSource.getHistoricalRates(
              tFromCurrency,
              tToCurrency,
              tStartDate,
              tEndDate,
            ),
          ).thenThrow(const ServerException(message: 'Server error'));
          when(
            () => mockLocalDataSource.getHistoricalRates(
              tFromCurrency,
              tToCurrency,
              tStartDate,
              tEndDate,
            ),
          ).thenAnswer((_) async => tHistoricalRateModels);

          final result = await repository.getHistoricalRates(
            tFromCurrency,
            tToCurrency,
            tStartDate,
            tEndDate,
          );

          expect(result, equals(Right(tHistoricalRateModels)));
        },
      );

      test(
        'should return ServerFailure when remote fails and cache is empty',
        () async {
          when(
            () => mockLocalDataSource.hasCachedRates(
              tFromCurrency,
              tToCurrency,
              tStartDate,
              tEndDate,
            ),
          ).thenAnswer((_) async => false);
          when(
            () => mockRemoteDataSource.getHistoricalRates(
              tFromCurrency,
              tToCurrency,
              tStartDate,
              tEndDate,
            ),
          ).thenThrow(const ServerException(message: 'Server error'));
          when(
            () => mockLocalDataSource.getHistoricalRates(
              tFromCurrency,
              tToCurrency,
              tStartDate,
              tEndDate,
            ),
          ).thenAnswer((_) async => []);

          final result = await repository.getHistoricalRates(
            tFromCurrency,
            tToCurrency,
            tStartDate,
            tEndDate,
          );

          expect(
            result,
            equals(const Left(ServerFailure(message: 'Server error'))),
          );
        },
      );

      test('should return CacheFailure when cache operation fails', () async {
        when(
          () => mockLocalDataSource.hasCachedRates(
            tFromCurrency,
            tToCurrency,
            tStartDate,
            tEndDate,
          ),
        ).thenThrow(const CacheException(message: 'Cache read failed'));

        final result = await repository.getHistoricalRates(
          tFromCurrency,
          tToCurrency,
          tStartDate,
          tEndDate,
        );

        expect(
          result,
          equals(const Left(CacheFailure(message: 'Cache read failed'))),
        );
      });
    });
  });
}
