import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/constants/api_constants.dart';
import 'package:task_currency/core/error/exceptions.dart';
import 'package:task_currency/features/converter/data/datasources/converter_remote_datasource.dart';
import 'package:task_currency/features/converter/data/models/conversion_model.dart';

import '../../../../mocks.dart';

void main() {
  late ConverterRemoteDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = ConverterRemoteDataSourceImpl(mockDioClient);
  });

  group('ConverterRemoteDataSourceImpl', () {
    const tFromCurrency = 'USD';
    const tToCurrency = 'EUR';
    const tAmount = 100.0;
    const tRate = 0.85;
    const tConversionResult = 85.0;

    final tSuccessResponse = {
      'result': 'success',
      'conversion_rate': tRate,
      'conversion_result': tConversionResult,
    };

    group('convertCurrency', () {
      test('should return ConversionModel when API call succeeds', () async {
        when(
          () => mockDioClient.get(
            ApiConstants.pairConversion(tFromCurrency, tToCurrency, tAmount),
          ),
        ).thenAnswer((_) async => tSuccessResponse);

        final result = await dataSource.convertCurrency(
          tFromCurrency,
          tToCurrency,
          tAmount,
        );

        expect(result, isA<ConversionModel>());
        expect(result.fromCurrency, equals(tFromCurrency));
        expect(result.toCurrency, equals(tToCurrency));
        expect(result.amount, equals(tAmount));
        expect(result.rate, equals(tRate));
        expect(result.result, equals(tConversionResult));
      });

      test(
        'should throw ServerException when API returns error result',
        () async {
          when(
            () => mockDioClient.get(
              ApiConstants.pairConversion(tFromCurrency, tToCurrency, tAmount),
            ),
          ).thenAnswer(
            (_) async => {'result': 'error', 'error-type': 'invalid-key'},
          );

          expect(
            () =>
                dataSource.convertCurrency(tFromCurrency, tToCurrency, tAmount),
            throwsA(isA<ServerException>()),
          );
        },
      );

      test('should throw ServerException when API returns null', () async {
        when(
          () => mockDioClient.get(
            ApiConstants.pairConversion(tFromCurrency, tToCurrency, tAmount),
          ),
        ).thenAnswer((_) async => null);

        expect(
          () => dataSource.convertCurrency(tFromCurrency, tToCurrency, tAmount),
          throwsA(isA<ServerException>()),
        );
      });

      test(
        'should throw ServerException with default message when error-type is missing',
        () async {
          when(
            () => mockDioClient.get(
              ApiConstants.pairConversion(tFromCurrency, tToCurrency, tAmount),
            ),
          ).thenAnswer((_) async => {'result': 'error'});

          expect(
            () =>
                dataSource.convertCurrency(tFromCurrency, tToCurrency, tAmount),
            throwsA(
              predicate<ServerException>(
                (e) => e.message == 'Conversion failed',
              ),
            ),
          );
        },
      );
    });
  });
}
