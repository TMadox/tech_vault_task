import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/error/exceptions.dart';
import 'package:task_currency/core/network/dio_client.dart';
import 'package:task_currency/features/currencies/data/datasources/currencies_remote_datasource.dart';
import 'package:task_currency/features/currencies/data/models/currency_model.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late CurrenciesRemoteDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = CurrenciesRemoteDataSourceImpl(mockDioClient);
  });

  group('getCurrencies', () {
    final tCurrenciesResponse = {
      'results': {
        'USD': {'currencyName': 'United States Dollar', 'currencySymbol': '\$'},
        'EUR': {'currencyName': 'Euro', 'currencySymbol': '€'},
        'KWD': {'currencyName': 'Kuwaiti Dinar', 'currencySymbol': 'KD'},
      },
    };

    test('should return list of CurrencyModel when API call is successful', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => tCurrenciesResponse);

      final result = await dataSource.getCurrencies();

      expect(result, isA<List<CurrencyModel>>());
      expect(result.length, 3);
      verify(() => mockDioClient.get(any())).called(1);
    });

    test('should return currencies sorted by name', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => tCurrenciesResponse);

      final result = await dataSource.getCurrencies();

      expect(result[0].currencyName, 'Euro');
      expect(result[1].currencyName, 'Kuwaiti Dinar');
      expect(result[2].currencyName, 'United States Dollar');
    });

    test('should throw ServerException when response is null', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => null);

      expect(() => dataSource.getCurrencies(), throwsA(isA<ServerException>()));
    });

    test('should throw ServerException when results is null', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => {'results': null});

      expect(() => dataSource.getCurrencies(), throwsA(isA<ServerException>()));
    });

    test('should correctly extract country code from currency id', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async => tCurrenciesResponse);

      final result = await dataSource.getCurrencies();

      final usd = result.firstWhere((c) => c.id == 'USD');
      final eur = result.firstWhere((c) => c.id == 'EUR');

      expect(usd.countryCode, 'us');
      expect(eur.countryCode, 'eu');
    });
  });
}
