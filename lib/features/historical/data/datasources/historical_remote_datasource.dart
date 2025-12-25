import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/historical_rate_model.dart';

abstract class HistoricalRemoteDataSource {
  Future<List<HistoricalRateModel>> getHistoricalRates(String fromCurrency, String toCurrency, DateTime startDate, DateTime endDate);
}

@LazySingleton(as: HistoricalRemoteDataSource)
class HistoricalRemoteDataSourceImpl implements HistoricalRemoteDataSource {
  final DioClient _dioClient;

  HistoricalRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<HistoricalRateModel>> getHistoricalRates(String fromCurrency, String toCurrency, DateTime startDate, DateTime endDate) async {
    try {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final url = ApiConstants.getHistoricalUrl(fromCurrency, toCurrency, dateFormat.format(startDate), dateFormat.format(endDate));

      final response = await _dioClient.get(url);

      if (response == null) {
        throw const ServerException(message: 'Invalid response from server');
      }

      final pairKey = '${fromCurrency}_$toCurrency';
      final ratesData = response[pairKey] as Map<String, dynamic>?;

      if (ratesData == null) {
        throw const ServerException(message: 'No historical data available');
      }

      final rates = <HistoricalRateModel>[];

      ratesData.forEach((dateString, rate) {
        rates.add(HistoricalRateModel.fromJson(fromCurrency, toCurrency, dateString, (rate as num).toDouble()));
      });

      rates.sort((a, b) => a.date.compareTo(b.date));

      return rates;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to fetch historical rates: $e');
    }
  }
}
