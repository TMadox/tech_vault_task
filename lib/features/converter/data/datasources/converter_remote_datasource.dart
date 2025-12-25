import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/conversion_model.dart';

abstract class ConverterRemoteDataSource {
  Future<ConversionModel> convertCurrency(String from, String to, double amount);
}

@Injectable(as: ConverterRemoteDataSource)
class ConverterRemoteDataSourceImpl implements ConverterRemoteDataSource {
  final DioClient _dioClient;

  ConverterRemoteDataSourceImpl(this._dioClient);

  @override
  Future<ConversionModel> convertCurrency(String from, String to, double amount) async {
    final response = await _dioClient.get(ApiConstants.pairConversion(from, to, amount));

    if (response == null || response['result'] != 'success') {
      throw ServerException(message: response?['error-type'] ?? 'Conversion failed');
    }

    final rate = (response['conversion_rate'] as num).toDouble();
    final result = (response['conversion_result'] as num).toDouble();

    return ConversionModel(fromCurrency: from, toCurrency: to, amount: amount, rate: rate, result: result);
  }
}
