import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/error/failures.dart';
import 'package:task_currency/features/converter/domain/entities/conversion_result.dart';
import 'package:task_currency/features/converter/domain/usecases/convert_currency.dart';

import '../../../../mocks.dart';

void main() {
  late ConvertCurrency usecase;
  late MockConverterRepository mockRepository;

  setUp(() {
    mockRepository = MockConverterRepository();
    usecase = ConvertCurrency(mockRepository);
  });

  group('ConvertCurrency', () {
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

    const tParams = ConvertCurrencyParams(
      fromCurrency: tFromCurrency,
      toCurrency: tToCurrency,
      amount: tAmount,
    );

    test(
      'should return ConversionResult when repository call succeeds',
      () async {
        when(
          () => mockRepository.convertCurrency(
            tFromCurrency,
            tToCurrency,
            tAmount,
          ),
        ).thenAnswer((_) async => const Right(tConversionResult));

        final result = await usecase(tParams);

        expect(result, equals(const Right(tConversionResult)));
        verify(
          () => mockRepository.convertCurrency(
            tFromCurrency,
            tToCurrency,
            tAmount,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return ServerFailure when repository call fails', () async {
      const tFailure = ServerFailure(message: 'Conversion failed');
      when(
        () =>
            mockRepository.convertCurrency(tFromCurrency, tToCurrency, tAmount),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, equals(const Left(tFailure)));
      verify(
        () =>
            mockRepository.convertCurrency(tFromCurrency, tToCurrency, tAmount),
      ).called(1);
    });
  });

  group('ConvertCurrencyParams', () {
    test('should have correct props', () {
      const params1 = ConvertCurrencyParams(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        amount: 100.0,
      );
      const params2 = ConvertCurrencyParams(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        amount: 100.0,
      );
      const params3 = ConvertCurrencyParams(
        fromCurrency: 'EUR',
        toCurrency: 'USD',
        amount: 100.0,
      );

      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });
  });
}
