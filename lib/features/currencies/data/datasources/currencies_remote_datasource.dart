import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/currency_model.dart';

abstract class CurrenciesRemoteDataSource {
  Future<List<CurrencyModel>> getCurrencies();
}

@LazySingleton(as: CurrenciesRemoteDataSource)
class CurrenciesRemoteDataSourceImpl implements CurrenciesRemoteDataSource {
  final DioClient _dioClient;

  CurrenciesRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<CurrencyModel>> getCurrencies() async {
    try {
      final response = await _dioClient.get(ApiConstants.getCurrenciesUrl());

      if (response == null || response['results'] == null) {
        throw const ServerException(message: 'Invalid response from server');
      }

      final results = response['results'] as Map<String, dynamic>;

      return results.entries.map((entry) => CurrencyModel.fromJson(entry.key, entry.value as Map<String, dynamic>)).toList()
        ..sort((a, b) => a.currencyName.compareTo(b.currencyName));
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to fetch currencies: $e');
    }
  }
}
