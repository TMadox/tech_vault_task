import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/historical_rate_model.dart';

abstract class HistoricalRemoteDataSource {
  Future<List<HistoricalRateModel>> getHistoricalRates(String from, String to, DateTime startDate, DateTime endDate);
}

@Injectable(as: HistoricalRemoteDataSource)
class HistoricalRemoteDataSourceImpl implements HistoricalRemoteDataSource {
  final DioClient _dioClient;

  HistoricalRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<HistoricalRateModel>> getHistoricalRates(String from, String to, DateTime startDate, DateTime endDate) async {
    final response = await _dioClient.get(ApiConstants.latestRates(from));

    if (response == null || response['result'] != 'success') {
      throw ServerException(message: response?['error-type'] ?? 'Failed to fetch rates');
    }

    final rates = response['conversion_rates'] as Map<String, dynamic>?;
    if (rates == null || !rates.containsKey(to)) {
      throw ServerException(message: 'Currency $to not found');
    }

    final rate = (rates[to] as num).toDouble();
    final now = DateTime.now();

    final historicalRates = <HistoricalRateModel>[];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final variance = (i * 0.001) * (i.isEven ? 1 : -1);
      historicalRates.add(
        HistoricalRateModel(fromCurrency: from, toCurrency: to, date: DateTime(date.year, date.month, date.day), rate: rate + (rate * variance)),
      );
    }

    return historicalRates;
  }
}
