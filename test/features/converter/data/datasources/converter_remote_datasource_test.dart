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

    final tConversionResponse = {'USD_KWD': tRate};

    test('should return ConversionModel when API call is successful', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => tConversionResponse);

      final result = await dataSource.convertCurrency(tFromCurrency, tToCurrency, tAmount);

      expect(result, isA<ConversionModel>());
      expect(result.fromCurrency, tFromCurrency);
      expect(result.toCurrency, tToCurrency);
      expect(result.amount, tAmount);
      expect(result.rate, tRate);
      expect(result.result, tAmount * tRate);
      verify(() => mockDioClient.get(any())).called(1);
    });

    test('should throw ServerException when response is null', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => null);

      expect(() => dataSource.convertCurrency(tFromCurrency, tToCurrency, tAmount), throwsA(isA<ServerException>()));
    });

    test('should throw ServerException when rate is not available', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => {'OTHER_PAIR': 1.5});

      expect(() => dataSource.convertCurrency(tFromCurrency, tToCurrency, tAmount), throwsA(isA<ServerException>()));
    });

    test('should calculate result correctly', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => tConversionResponse);

      final result = await dataSource.convertCurrency(tFromCurrency, tToCurrency, 250.0);

      expect(result.result, closeTo(250.0 * tRate, 0.001));
    });
  });
}
