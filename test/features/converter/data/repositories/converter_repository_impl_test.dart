import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/error/exceptions.dart';
import 'package:task_currency/core/error/failures.dart';
import 'package:task_currency/features/converter/data/models/conversion_model.dart';
import 'package:task_currency/features/converter/data/repositories/converter_repository_impl.dart';

import '../../../../mocks.dart';

void main() {
  late ConverterRepositoryImpl repository;
  late MockConverterRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockConverterRemoteDataSource();
    repository = ConverterRepositoryImpl(mockRemoteDataSource);
  });

  group('ConverterRepositoryImpl', () {
    const tFromCurrency = 'USD';
    const tToCurrency = 'EUR';
    const tAmount = 100.0;
    const tRate = 0.85;
    const tResult = 85.0;

    const tConversionModel = ConversionModel(
      fromCurrency: tFromCurrency,
      toCurrency: tToCurrency,
      amount: tAmount,
      rate: tRate,
      result: tResult,
    );

    group('convertCurrency', () {
      test(
        'should return ConversionResult when remote data source call succeeds',
        () async {
          when(
            () => mockRemoteDataSource.convertCurrency(
              tFromCurrency,
              tToCurrency,
              tAmount,
            ),
          ).thenAnswer((_) async => tConversionModel);

          final result = await repository.convertCurrency(
            tFromCurrency,
            tToCurrency,
            tAmount,
          );

          expect(result, equals(const Right(tConversionModel)));
          verify(
            () => mockRemoteDataSource.convertCurrency(
              tFromCurrency,
              tToCurrency,
              tAmount,
            ),
          ).called(1);
        },
      );

      test(
        'should return ServerFailure when remote data source throws ServerException',
        () async {
          when(
            () => mockRemoteDataSource.convertCurrency(
              tFromCurrency,
              tToCurrency,
              tAmount,
            ),
          ).thenThrow(const ServerException(message: 'Conversion failed'));

          final result = await repository.convertCurrency(
            tFromCurrency,
            tToCurrency,
            tAmount,
          );

          expect(
            result,
            equals(const Left(ServerFailure(message: 'Conversion failed'))),
          );
        },
      );
    });
  });
}
