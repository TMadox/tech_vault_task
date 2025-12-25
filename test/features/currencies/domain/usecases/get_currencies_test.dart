import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/error/failures.dart';
import 'package:task_currency/core/usecases/usecase.dart';
import 'package:task_currency/features/currencies/domain/entities/currency.dart';
import 'package:task_currency/features/currencies/domain/repositories/currencies_repository.dart';
import 'package:task_currency/features/currencies/domain/usecases/get_currencies.dart';

class MockCurrenciesRepository extends Mock implements CurrenciesRepository {}

void main() {
  late GetCurrencies useCase;
  late MockCurrenciesRepository mockRepository;

  setUp(() {
    mockRepository = MockCurrenciesRepository();
    useCase = GetCurrencies(mockRepository);
  });

  final tCurrencies = [
    const Currency(id: 'USD', currencyName: 'United States Dollar', currencySymbol: '\$', countryCode: 'us'),
    const Currency(id: 'EUR', currencyName: 'Euro', currencySymbol: '€', countryCode: 'eu'),
  ];

  test('should get currencies from the repository', () async {
    when(() => mockRepository.getCurrencies()).thenAnswer((_) async => Right(tCurrencies));

    final result = await useCase(const NoParams());

    expect(result, Right(tCurrencies));
    verify(() => mockRepository.getCurrencies()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    const tFailure = ServerFailure(message: 'Server error');
    when(() => mockRepository.getCurrencies()).thenAnswer((_) async => const Left(tFailure));

    final result = await useCase(const NoParams());

    expect(result, const Left(tFailure));
    verify(() => mockRepository.getCurrencies()).called(1);
  });

  test('should return CacheFailure when cache fails', () async {
    const tFailure = CacheFailure(message: 'Cache error');
    when(() => mockRepository.getCurrencies()).thenAnswer((_) async => const Left(tFailure));

    final result = await useCase(const NoParams());

    expect(result, const Left(tFailure));
  });
}
