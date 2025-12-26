import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/error/failures.dart';
import 'package:task_currency/core/usecases/usecase.dart';
import 'package:task_currency/features/currencies/domain/entities/currency.dart';
import 'package:task_currency/features/currencies/presentation/bloc/currencies_bloc.dart';
import 'package:task_currency/features/currencies/presentation/bloc/currencies_event.dart';
import 'package:task_currency/features/currencies/presentation/bloc/currencies_state.dart';

import '../../../../mocks.dart';

void main() {
  late CurrenciesBloc bloc;
  late MockGetCurrencies mockGetCurrencies;

  setUp(() {
    mockGetCurrencies = MockGetCurrencies();
    bloc = CurrenciesBloc(mockGetCurrencies);
  });

  tearDown(() {
    bloc.close();
  });

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  group('CurrenciesBloc', () {
    const tCurrencies = [
      Currency(id: 'USD', currencyName: 'United States Dollar'),
      Currency(id: 'EUR', currencyName: 'Euro'),
      Currency(id: 'GBP', currencyName: 'British Pound'),
    ];

    test('initial state should be CurrenciesInitial', () {
      expect(bloc.state, equals(const CurrenciesInitial()));
    });

    blocTest<CurrenciesBloc, CurrenciesState>(
      'emits [CurrenciesLoading, CurrenciesLoaded] when LoadCurrencies '
      'is added and fetching succeeds',
      build: () {
        when(
          () => mockGetCurrencies(any()),
        ).thenAnswer((_) async => const Right(tCurrencies));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadCurrencies()),
      expect: () => [
        const CurrenciesLoading(),
        const CurrenciesLoaded(currencies: tCurrencies),
      ],
      verify: (_) {
        verify(() => mockGetCurrencies(const NoParams())).called(1);
      },
    );

    blocTest<CurrenciesBloc, CurrenciesState>(
      'emits [CurrenciesLoading, CurrenciesError] when LoadCurrencies '
      'is added and fetching fails',
      build: () {
        when(() => mockGetCurrencies(any())).thenAnswer(
          (_) async =>
              const Left(ServerFailure(message: 'Failed to fetch currencies')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadCurrencies()),
      expect: () => [
        const CurrenciesLoading(),
        const CurrenciesError(message: 'Failed to fetch currencies'),
      ],
    );

    blocTest<CurrenciesBloc, CurrenciesState>(
      'emits [CurrenciesLoading, CurrenciesError] when LoadCurrencies '
      'is added and cache fails',
      build: () {
        when(() => mockGetCurrencies(any())).thenAnswer(
          (_) async =>
              const Left(CacheFailure(message: 'Failed to read cache')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadCurrencies()),
      expect: () => [
        const CurrenciesLoading(),
        const CurrenciesError(message: 'Failed to read cache'),
      ],
    );
  });
}
