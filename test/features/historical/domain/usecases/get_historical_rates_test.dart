import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/error/failures.dart';
import 'package:task_currency/features/historical/domain/entities/historical_rate.dart';
import 'package:task_currency/features/historical/domain/usecases/get_historical_rates.dart';

import '../../../../mocks.dart';

void main() {
  late GetHistoricalRates usecase;
  late MockHistoricalRepository mockRepository;

  setUp(() {
    mockRepository = MockHistoricalRepository();
    usecase = GetHistoricalRates(mockRepository);
  });

  group('GetHistoricalRates', () {
    const tFromCurrency = 'USD';
    const tToCurrency = 'KWD';
    final tStartDate = DateTime(2025, 1, 1);
    final tEndDate = DateTime(2025, 1, 7);

    final tRates = [
      HistoricalRate(
        fromCurrency: tFromCurrency,
        toCurrency: tToCurrency,
        date: DateTime(2025, 1, 1),
        rate: 0.307,
      ),
      HistoricalRate(
        fromCurrency: tFromCurrency,
        toCurrency: tToCurrency,
        date: DateTime(2025, 1, 2),
        rate: 0.308,
      ),
    ];

    final tParams = HistoricalRatesParams(
      fromCurrency: tFromCurrency,
      toCurrency: tToCurrency,
      startDate: tStartDate,
      endDate: tEndDate,
    );

    test(
      'should return list of historical rates when repository call succeeds',
      () async {
        when(
          () => mockRepository.getHistoricalRates(
            tFromCurrency,
            tToCurrency,
            tStartDate,
            tEndDate,
          ),
        ).thenAnswer((_) async => Right(tRates));

        final result = await usecase(tParams);

        expect(result, equals(Right(tRates)));
        verify(
          () => mockRepository.getHistoricalRates(
            tFromCurrency,
            tToCurrency,
            tStartDate,
            tEndDate,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return ServerFailure when repository call fails', () async {
      const tFailure = ServerFailure(message: 'Failed to fetch rates');
      when(
        () => mockRepository.getHistoricalRates(
          tFromCurrency,
          tToCurrency,
          tStartDate,
          tEndDate,
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, equals(const Left(tFailure)));
      verify(
        () => mockRepository.getHistoricalRates(
          tFromCurrency,
          tToCurrency,
          tStartDate,
          tEndDate,
        ),
      ).called(1);
    });

    test('should return CacheFailure when cache operation fails', () async {
      const tFailure = CacheFailure(message: 'Cache read failed');
      when(
        () => mockRepository.getHistoricalRates(
          tFromCurrency,
          tToCurrency,
          tStartDate,
          tEndDate,
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, equals(const Left(tFailure)));
    });
  });

  group('HistoricalRatesParams', () {
    test('should have correct props', () {
      final params1 = HistoricalRatesParams(
        fromCurrency: 'USD',
        toCurrency: 'KWD',
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 7),
      );
      final params2 = HistoricalRatesParams(
        fromCurrency: 'USD',
        toCurrency: 'KWD',
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 7),
      );
      final params3 = HistoricalRatesParams(
        fromCurrency: 'EUR',
        toCurrency: 'KWD',
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 7),
      );

      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });
  });
}
