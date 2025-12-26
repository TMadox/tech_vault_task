import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/constants/app_constants.dart';
import 'package:task_currency/core/error/failures.dart';
import 'package:task_currency/features/historical/domain/entities/historical_rate.dart';
import 'package:task_currency/features/historical/domain/usecases/get_historical_rates.dart';
import 'package:task_currency/features/historical/presentation/bloc/historical_bloc.dart';
import 'package:task_currency/features/historical/presentation/bloc/historical_event.dart';
import 'package:task_currency/features/historical/presentation/bloc/historical_state.dart';

import '../../../../mocks.dart';

void main() {
  late HistoricalBloc bloc;
  late MockGetHistoricalRates mockGetHistoricalRates;

  setUp(() {
    mockGetHistoricalRates = MockGetHistoricalRates();
    bloc = HistoricalBloc(mockGetHistoricalRates);
  });

  tearDown(() {
    bloc.close();
  });

  setUpAll(() {
    registerFallbackValue(
      HistoricalRatesParams(
        fromCurrency: 'USD',
        toCurrency: 'KWD',
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 7),
      ),
    );
  });

  group('HistoricalBloc', () {
    final tRates = [
      HistoricalRate(
        fromCurrency: 'USD',
        toCurrency: 'KWD',
        date: DateTime(2025, 1, 1),
        rate: 0.307,
      ),
      HistoricalRate(
        fromCurrency: 'USD',
        toCurrency: 'KWD',
        date: DateTime(2025, 1, 2),
        rate: 0.308,
      ),
    ];

    test('initial state should be HistoricalInitial', () {
      expect(bloc.state, equals(const HistoricalInitial()));
    });

    blocTest<HistoricalBloc, HistoricalState>(
      'emits [HistoricalLoading, HistoricalLoaded] when LoadHistoricalRates '
      'is added and fetching succeeds',
      build: () {
        when(
          () => mockGetHistoricalRates(any()),
        ).thenAnswer((_) async => Right(tRates));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadHistoricalRates()),
      expect: () => [
        const HistoricalLoading(),
        HistoricalLoaded(
          rates: tRates,
          fromCurrency: AppConstants.historicalFromCurrency,
          toCurrency: AppConstants.historicalToCurrency,
        ),
      ],
      verify: (_) {
        verify(() => mockGetHistoricalRates(any())).called(1);
      },
    );

    blocTest<HistoricalBloc, HistoricalState>(
      'emits [HistoricalLoading, HistoricalError] when LoadHistoricalRates '
      'is added and fetching fails',
      build: () {
        when(() => mockGetHistoricalRates(any())).thenAnswer(
          (_) async =>
              const Left(ServerFailure(message: 'Failed to fetch rates')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadHistoricalRates()),
      expect: () => [
        const HistoricalLoading(),
        const HistoricalError(message: 'Failed to fetch rates'),
      ],
    );

    blocTest<HistoricalBloc, HistoricalState>(
      'emits [HistoricalLoading, HistoricalError] when LoadHistoricalRates '
      'is added and cache fails',
      build: () {
        when(() => mockGetHistoricalRates(any())).thenAnswer(
          (_) async =>
              const Left(CacheFailure(message: 'Failed to read cache')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadHistoricalRates()),
      expect: () => [
        const HistoricalLoading(),
        const HistoricalError(message: 'Failed to read cache'),
      ],
    );
  });
}
