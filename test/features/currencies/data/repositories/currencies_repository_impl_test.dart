import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/error/exceptions.dart';
import 'package:task_currency/core/error/failures.dart';
import 'package:task_currency/features/currencies/data/models/currency_model.dart';
import 'package:task_currency/features/currencies/data/repositories/currencies_repository_impl.dart';

import '../../../../mocks.dart';

void main() {
  late CurrenciesRepositoryImpl repository;
  late MockCurrenciesRemoteDataSource mockRemoteDataSource;
  late MockCurrenciesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockCurrenciesRemoteDataSource();
    mockLocalDataSource = MockCurrenciesLocalDataSource();
    repository = CurrenciesRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
    );
  });

  setUpAll(() {
    registerFallbackValue(<CurrencyModel>[]);
  });

  group('CurrenciesRepositoryImpl', () {
    const tCurrencyModels = [
      CurrencyModel(id: 'USD', currencyName: 'United States Dollar'),
      CurrencyModel(id: 'EUR', currencyName: 'Euro'),
    ];

    group('getCurrencies', () {
      test('should return cached currencies when cache is valid', () async {
        when(
          () => mockLocalDataSource.hasCachedCurrencies(),
        ).thenAnswer((_) async => true);
        when(
          () => mockLocalDataSource.getCurrencies(),
        ).thenAnswer((_) async => tCurrencyModels);

        final result = await repository.getCurrencies();

        expect(result, equals(const Right(tCurrencyModels)));
        verify(() => mockLocalDataSource.hasCachedCurrencies()).called(1);
        verify(() => mockLocalDataSource.getCurrencies()).called(1);
        verifyNever(() => mockRemoteDataSource.getCurrencies());
      });

      test(
        'should fetch from remote and cache when no cached currencies exist',
        () async {
          when(
            () => mockLocalDataSource.hasCachedCurrencies(),
          ).thenAnswer((_) async => false);
          when(
            () => mockRemoteDataSource.getCurrencies(),
          ).thenAnswer((_) async => tCurrencyModels);
          when(
            () => mockLocalDataSource.cacheCurrencies(any()),
          ).thenAnswer((_) async {});

          final result = await repository.getCurrencies();

          expect(result, equals(const Right(tCurrencyModels)));
          verify(() => mockLocalDataSource.hasCachedCurrencies()).called(1);
          verify(() => mockRemoteDataSource.getCurrencies()).called(1);
          verify(
            () => mockLocalDataSource.cacheCurrencies(tCurrencyModels),
          ).called(1);
        },
      );

      test(
        'should return cached currencies when remote fails and cache is available',
        () async {
          when(
            () => mockLocalDataSource.hasCachedCurrencies(),
          ).thenAnswer((_) async => false);
          when(
            () => mockRemoteDataSource.getCurrencies(),
          ).thenThrow(const ServerException(message: 'Server error'));
          when(
            () => mockLocalDataSource.hasCachedCurrencies(),
          ).thenAnswer((_) async => true);
          when(
            () => mockLocalDataSource.getCurrencies(),
          ).thenAnswer((_) async => tCurrencyModels);

          final result = await repository.getCurrencies();

          expect(result, equals(const Right(tCurrencyModels)));
        },
      );

      test(
        'should return ServerFailure when remote fails and no cache available',
        () async {
          when(
            () => mockLocalDataSource.hasCachedCurrencies(),
          ).thenAnswer((_) async => false);
          when(
            () => mockRemoteDataSource.getCurrencies(),
          ).thenThrow(const ServerException(message: 'Server error'));

          final result = await repository.getCurrencies();

          expect(
            result,
            equals(const Left(ServerFailure(message: 'Server error'))),
          );
        },
      );

      test('should return CacheFailure when cache operation fails', () async {
        when(
          () => mockLocalDataSource.hasCachedCurrencies(),
        ).thenThrow(const CacheException(message: 'Cache read failed'));

        final result = await repository.getCurrencies();

        expect(
          result,
          equals(const Left(CacheFailure(message: 'Cache read failed'))),
        );
      });
    });
  });
}
