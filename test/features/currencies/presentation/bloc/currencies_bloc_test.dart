import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/error/failures.dart';
import 'package:task_currency/core/usecases/usecase.dart';
import 'package:task_currency/features/currencies/domain/entities/currency.dart';
import 'package:task_currency/features/currencies/domain/usecases/get_currencies.dart';
import 'package:task_currency/features/currencies/presentation/bloc/currencies_bloc.dart';
import 'package:task_currency/features/currencies/presentation/bloc/currencies_event.dart';
import 'package:task_currency/features/currencies/presentation/bloc/currencies_state.dart';

class MockGetCurrencies extends Mock implements GetCurrencies {}

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

  test('initial state should be CurrenciesInitial', () {
    expect(bloc.state, const CurrenciesInitial());
  });

  final tCurrencies = [
    const Currency(id: 'USD', currencyName: 'United States Dollar', currencySymbol: '\$', countryCode: 'us'),
    const Currency(id: 'KWD', currencyName: 'Kuwaiti Dinar', currencySymbol: 'KD', countryCode: 'kw'),
  ];

  blocTest<CurrenciesBloc, CurrenciesState>(
    'emits [CurrenciesLoading, CurrenciesLoaded] when LoadCurrencies is successful',
    build: () {
      when(() => mockGetCurrencies(const NoParams())).thenAnswer((_) async => Right(tCurrencies));
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadCurrencies()),
    expect: () => [const CurrenciesLoading(), CurrenciesLoaded(currencies: tCurrencies)],
    verify: (_) {
      verify(() => mockGetCurrencies(const NoParams())).called(1);
    },
  );

  blocTest<CurrenciesBloc, CurrenciesState>(
    'emits [CurrenciesLoading, CurrenciesError] when LoadCurrencies fails',
    build: () {
      when(() => mockGetCurrencies(const NoParams())).thenAnswer((_) async => const Left(ServerFailure(message: 'Server error')));
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadCurrencies()),
    expect: () => [const CurrenciesLoading(), const CurrenciesError(message: 'Server error')],
  );
}
