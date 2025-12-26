import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/error/failures.dart';
import 'package:task_currency/core/usecases/usecase.dart';
import 'package:task_currency/features/currencies/domain/entities/currency.dart';
import 'package:task_currency/features/currencies/domain/usecases/get_currencies.dart';

import '../../../../mocks.dart';

void main() {
  late GetCurrencies usecase;
  late MockCurrenciesRepository mockRepository;

  setUp(() {
    mockRepository = MockCurrenciesRepository();
    usecase = GetCurrencies(mockRepository);
  });

  group('GetCurrencies', () {
    const tCurrencies = [
      Currency(id: 'USD', currencyName: 'United States Dollar'),
      Currency(id: 'EUR', currencyName: 'Euro'),
      Currency(id: 'GBP', currencyName: 'British Pound'),
    ];

    test(
      'should return list of currencies when repository call succeeds',
      () async {
        when(
          () => mockRepository.getCurrencies(),
        ).thenAnswer((_) async => const Right(tCurrencies));

        final result = await usecase(const NoParams());

        expect(result, equals(const Right(tCurrencies)));
        verify(() => mockRepository.getCurrencies()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return ServerFailure when repository call fails', () async {
      const tFailure = ServerFailure(message: 'Failed to fetch currencies');
      when(
        () => mockRepository.getCurrencies(),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(const NoParams());

      expect(result, equals(const Left(tFailure)));
      verify(() => mockRepository.getCurrencies()).called(1);
    });

    test('should return CacheFailure when cache operation fails', () async {
      const tFailure = CacheFailure(message: 'Cache read failed');
      when(
        () => mockRepository.getCurrencies(),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(const NoParams());

      expect(result, equals(const Left(tFailure)));
    });
  });
}
