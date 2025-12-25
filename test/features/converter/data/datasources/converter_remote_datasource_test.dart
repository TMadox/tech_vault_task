import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/error/exceptions.dart';
import 'package:task_currency/core/network/dio_client.dart';
import 'package:task_currency/features/converter/data/datasources/converter_remote_datasource.dart';
import 'package:task_currency/features/converter/data/models/conversion_model.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late ConverterRemoteDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = ConverterRemoteDataSourceImpl(mockDioClient);
  });

  group('convertCurrency', () {
    const tFromCurrency = 'USD';
    const tToCurrency = 'KWD';
    const tAmount = 100.0;
    const tRate = 0.307;
    const tResult = 30.7;

    final tConversionResponse = {
      'result': 'success',
      'base_code': tFromCurrency,
      'target_code': tToCurrency,
      'conversion_rate': tRate,
      'conversion_result': tResult,
    };

    test('should return ConversionModel when API call is successful', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => tConversionResponse);

      final result = await dataSource.convertCurrency(tFromCurrency, tToCurrency, tAmount);

      expect(result, isA<ConversionModel>());
      expect(result.fromCurrency, tFromCurrency);
      expect(result.toCurrency, tToCurrency);
      expect(result.amount, tAmount);
      expect(result.rate, tRate);
      expect(result.result, tResult);
      verify(() => mockDioClient.get(any())).called(1);
    });

    test('should throw ServerException when response is null', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => null);

      expect(() => dataSource.convertCurrency(tFromCurrency, tToCurrency, tAmount), throwsA(isA<ServerException>()));
    });

    test('should throw ServerException when result is not success', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => {'result': 'error', 'error-type': 'invalid-key'});

      expect(() => dataSource.convertCurrency(tFromCurrency, tToCurrency, tAmount), throwsA(isA<ServerException>()));
    });
  });
}
