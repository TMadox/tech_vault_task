import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/error/failures.dart';
import 'package:task_currency/features/converter/domain/entities/conversion_result.dart';
import 'package:task_currency/features/converter/domain/repositories/converter_repository.dart';
import 'package:task_currency/features/converter/domain/usecases/convert_currency.dart';

class MockConverterRepository extends Mock implements ConverterRepository {}

void main() {
  late ConvertCurrency useCase;
  late MockConverterRepository mockRepository;

  setUp(() {
    mockRepository = MockConverterRepository();
    useCase = ConvertCurrency(mockRepository);
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

  test('should convert currency through the repository', () async {
    when(() => mockRepository.convertCurrency(tFromCurrency, tToCurrency, tAmount)).thenAnswer((_) async => const Right(tConversionResult));

    final result = await useCase(const ConvertCurrencyParams(fromCurrency: tFromCurrency, toCurrency: tToCurrency, amount: tAmount));

    expect(result, const Right(tConversionResult));
    verify(() => mockRepository.convertCurrency(tFromCurrency, tToCurrency, tAmount)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when conversion fails', () async {
    const tFailure = ServerFailure(message: 'Conversion error');
    when(() => mockRepository.convertCurrency(any(), any(), any())).thenAnswer((_) async => const Left(tFailure));

    final result = await useCase(const ConvertCurrencyParams(fromCurrency: tFromCurrency, toCurrency: tToCurrency, amount: tAmount));

    expect(result, const Left(tFailure));
  });

  test('ConvertCurrencyParams props should be correct', () {
    const params = ConvertCurrencyParams(fromCurrency: tFromCurrency, toCurrency: tToCurrency, amount: tAmount);

    expect(params.props, [tFromCurrency, tToCurrency, tAmount]);
  });
}
