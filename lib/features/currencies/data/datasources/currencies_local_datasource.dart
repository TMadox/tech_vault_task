import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../models/currency_model.dart';

abstract class CurrenciesLocalDataSource {
  Future<List<CurrencyModel>> getCurrencies();
  Future<void> cacheCurrencies(List<CurrencyModel> currencies);
  Future<bool> hasCachedCurrencies();
}

@LazySingleton(as: CurrenciesLocalDataSource)
class CurrenciesLocalDataSourceImpl implements CurrenciesLocalDataSource {
  final AppDatabase _database;

  CurrenciesLocalDataSourceImpl(this._database);

  @override
  Future<List<CurrencyModel>> getCurrencies() async {
    try {
      final results = await _database.select(_database.currenciesTable).get();
      return results.map((data) => CurrencyModel.fromTableData(data)).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get cached currencies: $e');
    }
  }

  @override
  Future<void> cacheCurrencies(List<CurrencyModel> currencies) async {
    try {
      await _database.batch((batch) {
        batch.insertAllOnConflictUpdate(_database.currenciesTable, currencies.map((c) => c.toCompanion()).toList());
      });
    } catch (e) {
      throw CacheException(message: 'Failed to cache currencies: $e');
    }
  }

  @override
  Future<bool> hasCachedCurrencies() async {
    try {
      final count = await _database.currenciesTable.count().getSingle();
      return count > 0;
    } catch (e) {
      return false;
    }
  }
}
