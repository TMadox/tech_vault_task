import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/constants/api_constants.dart';
import 'package:task_currency/core/error/exceptions.dart';
import 'package:task_currency/features/currencies/data/datasources/currencies_remote_datasource.dart';
import 'package:task_currency/features/currencies/data/models/currency_model.dart';

import '../../../../mocks.dart';

void main() {
  late CurrenciesRemoteDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = CurrenciesRemoteDataSourceImpl(mockDioClient);
  });

  group('CurrenciesRemoteDataSourceImpl', () {
    final tSuccessResponse = {
      'result': 'success',
      'supported_codes': [
        ['USD', 'United States Dollar'],
        ['EUR', 'Euro'],
        ['GBP', 'British Pound'],
      ],
    };

    group('getCurrencies', () {
      test(
        'should return list of CurrencyModel when API call succeeds',
        () async {
          when(
            () => mockDioClient.get(ApiConstants.supportedCodes()),
          ).thenAnswer((_) async => tSuccessResponse);

          final result = await dataSource.getCurrencies();

          expect(result, isA<List<CurrencyModel>>());
          expect(result.length, equals(3));
          expect(result[0].id, equals('GBP')); // Sorted alphabetically by name
          expect(result[1].id, equals('EUR'));
          expect(result[2].id, equals('USD'));
        },
      );

      test('should sort currencies alphabetically by name', () async {
        when(
          () => mockDioClient.get(ApiConstants.supportedCodes()),
        ).thenAnswer((_) async => tSuccessResponse);

        final result = await dataSource.getCurrencies();

        expect(result[0].currencyName, equals('British Pound'));
        expect(result[1].currencyName, equals('Euro'));
        expect(result[2].currencyName, equals('United States Dollar'));
      });

      test(
        'should throw ServerException when API returns error result',
        () async {
          when(
            () => mockDioClient.get(ApiConstants.supportedCodes()),
          ).thenAnswer(
            (_) async => {'result': 'error', 'error-type': 'invalid-key'},
          );

          expect(
            () => dataSource.getCurrencies(),
            throwsA(isA<ServerException>()),
          );
        },
      );

      test('should throw ServerException when API returns null', () async {
        when(
          () => mockDioClient.get(ApiConstants.supportedCodes()),
        ).thenAnswer((_) async => null);

        expect(
          () => dataSource.getCurrencies(),
          throwsA(isA<ServerException>()),
        );
      });

      test(
        'should throw ServerException when supported_codes is null',
        () async {
          when(
            () => mockDioClient.get(ApiConstants.supportedCodes()),
          ).thenAnswer(
            (_) async => {'result': 'success', 'supported_codes': null},
          );

          expect(
            () => dataSource.getCurrencies(),
            throwsA(
              predicate<ServerException>(
                (e) => e.message == 'No currency data received',
              ),
            ),
          );
        },
      );
    });
  });
}
