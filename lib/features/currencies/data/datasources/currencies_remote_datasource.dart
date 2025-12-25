import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/currency_model.dart';

abstract class CurrenciesRemoteDataSource {
  Future<List<CurrencyModel>> getCurrencies();
}

@Injectable(as: CurrenciesRemoteDataSource)
class CurrenciesRemoteDataSourceImpl implements CurrenciesRemoteDataSource {
  final DioClient _dioClient;

  CurrenciesRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<CurrencyModel>> getCurrencies() async {
    final response = await _dioClient.get(ApiConstants.supportedCodes());

    if (response == null || response['result'] != 'success') {
      throw ServerException(message: response?['error-type'] ?? 'Failed to fetch currencies');
    }

    final supportedCodes = response['supported_codes'] as List<dynamic>?;
    if (supportedCodes == null) {
      throw ServerException(message: 'No currency data received');
    }

    final currencies = supportedCodes.map((item) {
      final codeData = item as List<dynamic>;
      return CurrencyModel.fromApiResponse(codeData[0] as String, codeData[1] as String);
    }).toList();

    currencies.sort((a, b) => a.currencyName.compareTo(b.currencyName));

    return currencies;
  }
}
