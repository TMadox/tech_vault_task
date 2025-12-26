import 'package:mocktail/mocktail.dart';
import 'package:task_currency/core/network/dio_client.dart';
import 'package:task_currency/features/converter/data/datasources/converter_remote_datasource.dart';
import 'package:task_currency/features/converter/domain/repositories/converter_repository.dart';
import 'package:task_currency/features/converter/domain/usecases/convert_currency.dart';
import 'package:task_currency/features/currencies/data/datasources/currencies_local_datasource.dart';
import 'package:task_currency/features/currencies/data/datasources/currencies_remote_datasource.dart';
import 'package:task_currency/features/currencies/domain/repositories/currencies_repository.dart';
import 'package:task_currency/features/currencies/domain/usecases/get_currencies.dart';
import 'package:task_currency/features/historical/data/datasources/historical_local_datasource.dart';
import 'package:task_currency/features/historical/data/datasources/historical_remote_datasource.dart';
import 'package:task_currency/features/historical/domain/repositories/historical_repository.dart';
import 'package:task_currency/features/historical/domain/usecases/get_historical_rates.dart';

// Use Cases
class MockConvertCurrency extends Mock implements ConvertCurrency {}

class MockGetCurrencies extends Mock implements GetCurrencies {}

class MockGetHistoricalRates extends Mock implements GetHistoricalRates {}

// Repositories
class MockConverterRepository extends Mock implements ConverterRepository {}

class MockCurrenciesRepository extends Mock implements CurrenciesRepository {}

class MockHistoricalRepository extends Mock implements HistoricalRepository {}

// Remote Data Sources
class MockConverterRemoteDataSource extends Mock
    implements ConverterRemoteDataSource {}

class MockCurrenciesRemoteDataSource extends Mock
    implements CurrenciesRemoteDataSource {}

class MockHistoricalRemoteDataSource extends Mock
    implements HistoricalRemoteDataSource {}

// Local Data Sources
class MockCurrenciesLocalDataSource extends Mock
    implements CurrenciesLocalDataSource {}

class MockHistoricalLocalDataSource extends Mock
    implements HistoricalLocalDataSource {}

// Network
class MockDioClient extends Mock implements DioClient {}
