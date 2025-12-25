import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/conversion_model.dart';

abstract class ConverterRemoteDataSource {
  Future<ConversionModel> convertCurrency(String fromCurrency, String toCurrency, double amount);
}

@LazySingleton(as: ConverterRemoteDataSource)
class ConverterRemoteDataSourceImpl implements ConverterRemoteDataSource {
  final DioClient _dioClient;

  ConverterRemoteDataSourceImpl(this._dioClient);

  @override
  Future<ConversionModel> convertCurrency(String fromCurrency, String toCurrency, double amount) async {
    try {
      final url = ApiConstants.getConvertUrl(fromCurrency, toCurrency);
      final response = await _dioClient.get(url);

      if (response == null) {
        throw const ServerException(message: 'Invalid response from server');
      }

      final pairKey = '${fromCurrency}_$toCurrency';
      final rate = response[pairKey];

      if (rate == null) {
        throw const ServerException(message: 'Conversion rate not available');
      }

      return ConversionModel.fromRate(fromCurrency, toCurrency, amount, (rate as num).toDouble());
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to convert currency: $e');
    }
  }
}
