import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/error/failures.dart';
import 'package:task_currency/features/converter/domain/entities/conversion_result.dart';
import 'package:task_currency/features/converter/domain/usecases/convert_currency.dart';
import 'package:task_currency/features/converter/presentation/bloc/converter_bloc.dart';
import 'package:task_currency/features/converter/presentation/bloc/converter_event.dart';
import 'package:task_currency/features/converter/presentation/bloc/converter_state.dart';

class MockConvertCurrency extends Mock implements ConvertCurrency {}

class FakeConvertCurrencyParams extends Fake implements ConvertCurrencyParams {}

void main() {
  late ConverterBloc bloc;
  late MockConvertCurrency mockConvertCurrency;

  setUpAll(() {
    registerFallbackValue(FakeConvertCurrencyParams());
  });

  setUp(() {
    mockConvertCurrency = MockConvertCurrency();
    bloc = ConverterBloc(mockConvertCurrency);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be ConverterInitial', () {
    expect(bloc.state, const ConverterInitial());
  });

  const tFromCurrency = 'USD';
  const tToCurrency = 'KWD';
  const tAmount = 100.0;
  const tRate = 0.307;

  const tConversionResult = ConversionResult(
    fromCurrency: tFromCurrency,
    toCurrency: tToCurrency,
    amount: tAmount,
    rate: tRate,
    result: tAmount * tRate,
  );

  blocTest<ConverterBloc, ConverterState>(
    'emits [ConverterLoading, ConverterSuccess] when ConvertCurrencyEvent is successful',
    build: () {
      when(() => mockConvertCurrency(any())).thenAnswer((_) async => const Right(tConversionResult));
      return bloc;
    },
    act: (bloc) => bloc.add(const ConvertCurrencyEvent(fromCurrency: tFromCurrency, toCurrency: tToCurrency, amount: tAmount)),
    expect: () => [const ConverterLoading(), const ConverterSuccess(result: tConversionResult)],
    verify: (_) {
      verify(() => mockConvertCurrency(any())).called(1);
    },
  );

  blocTest<ConverterBloc, ConverterState>(
    'emits [ConverterLoading, ConverterError] when ConvertCurrencyEvent fails',
    build: () {
      when(() => mockConvertCurrency(any())).thenAnswer((_) async => const Left(ServerFailure(message: 'Conversion error')));
      return bloc;
    },
    act: (bloc) => bloc.add(const ConvertCurrencyEvent(fromCurrency: tFromCurrency, toCurrency: tToCurrency, amount: tAmount)),
    expect: () => [const ConverterLoading(), const ConverterError(message: 'Conversion error')],
  );

  blocTest<ConverterBloc, ConverterState>(
    'emits [ConverterInitial] when ResetConverter is called',
    build: () => bloc,
    seed: () => const ConverterSuccess(result: tConversionResult),
    act: (bloc) => bloc.add(const ResetConverter()),
    expect: () => [const ConverterInitial()],
  );
}
