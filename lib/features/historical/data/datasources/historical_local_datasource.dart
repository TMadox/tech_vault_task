import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../models/historical_rate_model.dart';

abstract class HistoricalLocalDataSource {
  Future<List<HistoricalRateModel>> getHistoricalRates(String fromCurrency, String toCurrency, DateTime startDate, DateTime endDate);
  Future<void> cacheHistoricalRates(List<HistoricalRateModel> rates);
  Future<bool> hasCachedRates(String fromCurrency, String toCurrency, DateTime startDate, DateTime endDate);
}

@LazySingleton(as: HistoricalLocalDataSource)
class HistoricalLocalDataSourceImpl implements HistoricalLocalDataSource {
  final AppDatabase _database;

  HistoricalLocalDataSourceImpl(this._database);

  @override
  Future<List<HistoricalRateModel>> getHistoricalRates(String fromCurrency, String toCurrency, DateTime startDate, DateTime endDate) async {
    try {
      final query = _database.select(_database.historicalRatesTable)
        ..where((t) => t.fromCurrency.equals(fromCurrency))
        ..where((t) => t.toCurrency.equals(toCurrency))
        ..where((t) => t.date.isBetweenValues(startDate, endDate))
        ..orderBy([(t) => OrderingTerm.asc(t.date)]);

      final results = await query.get();
      return results.map((data) => HistoricalRateModel.fromTableData(data)).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get cached historical rates: $e');
    }
  }

  @override
  Future<void> cacheHistoricalRates(List<HistoricalRateModel> rates) async {
    try {
      await _database.batch((batch) {
        for (final rate in rates) {
          batch.insert(_database.historicalRatesTable, rate.toCompanion(), mode: InsertMode.insertOrReplace);
        }
      });
    } catch (e) {
      throw CacheException(message: 'Failed to cache historical rates: $e');
    }
  }

  @override
  Future<bool> hasCachedRates(String fromCurrency, String toCurrency, DateTime startDate, DateTime endDate) async {
    try {
      final query = _database.historicalRatesTable.count(
        where: (t) => t.fromCurrency.equals(fromCurrency) & t.toCurrency.equals(toCurrency) & t.date.isBetweenValues(startDate, endDate),
      );
      final count = await query.getSingle();
      final expectedDays = endDate.difference(startDate).inDays + 1;
      return count >= expectedDays;
    } catch (e) {
      return false;
    }
  }
}
