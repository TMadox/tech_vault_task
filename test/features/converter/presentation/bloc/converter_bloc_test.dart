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

import '../../../../mocks.dart';

void main() {
  late ConverterBloc bloc;
  late MockConvertCurrency mockConvertCurrency;

  setUp(() {
    mockConvertCurrency = MockConvertCurrency();
    bloc = ConverterBloc(mockConvertCurrency);
  });

  tearDown(() {
    bloc.close();
  });

  setUpAll(() {
    registerFallbackValue(
      const ConvertCurrencyParams(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        amount: 100.0,
      ),
    );
  });

  group('ConverterBloc', () {
    const tFromCurrency = 'USD';
    const tToCurrency = 'EUR';
    const tAmount = 100.0;
    const tRate = 0.85;
    const tResult = 85.0;

    const tConversionResult = ConversionResult(
      fromCurrency: tFromCurrency,
      toCurrency: tToCurrency,
      amount: tAmount,
      rate: tRate,
      result: tResult,
    );

    test('initial state should be ConverterInitial', () {
      expect(bloc.state, equals(const ConverterInitial()));
    });

    blocTest<ConverterBloc, ConverterState>(
      'emits [ConverterLoading, ConverterSuccess] when ConvertCurrencyEvent '
      'is added and conversion succeeds',
      build: () {
        when(
          () => mockConvertCurrency(any()),
        ).thenAnswer((_) async => const Right(tConversionResult));
        return bloc;
      },
      act: (bloc) => bloc.add(
        const ConvertCurrencyEvent(
          fromCurrency: tFromCurrency,
          toCurrency: tToCurrency,
          amount: tAmount,
        ),
      ),
      expect: () => [
        const ConverterLoading(),
        const ConverterSuccess(result: tConversionResult),
      ],
      verify: (_) {
        verify(
          () => mockConvertCurrency(
            const ConvertCurrencyParams(
              fromCurrency: tFromCurrency,
              toCurrency: tToCurrency,
              amount: tAmount,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<ConverterBloc, ConverterState>(
      'emits [ConverterLoading, ConverterError] when ConvertCurrencyEvent '
      'is added and conversion fails',
      build: () {
        when(() => mockConvertCurrency(any())).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Conversion failed')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const ConvertCurrencyEvent(
          fromCurrency: tFromCurrency,
          toCurrency: tToCurrency,
          amount: tAmount,
        ),
      ),
      expect: () => [
        const ConverterLoading(),
        const ConverterError(message: 'Conversion failed'),
      ],
    );

    blocTest<ConverterBloc, ConverterState>(
      'emits [ConverterInitial] when ResetConverter is added',
      build: () => bloc,
      seed: () => const ConverterSuccess(result: tConversionResult),
      act: (bloc) => bloc.add(const ResetConverter()),
      expect: () => [const ConverterInitial()],
    );
  });
}
