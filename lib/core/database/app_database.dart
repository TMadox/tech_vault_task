import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:injectable/injectable.dart';

part 'app_database.g.dart';

class CurrenciesTable extends Table {
  TextColumn get id => text()();
  TextColumn get currencyName => text()();
  TextColumn get currencySymbol => text().nullable()();
  TextColumn get countryCode => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class HistoricalRatesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fromCurrency => text()();
  TextColumn get toCurrency => text()();
  DateTimeColumn get date => dateTime()();
  RealColumn get rate => real()();

  @override
  List<Set<Column>>? get uniqueKeys => [
    {fromCurrency, toCurrency, date},
  ];
}

@lazySingleton
@DriftDatabase(tables: [CurrenciesTable, HistoricalRatesTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'currency_converter_db');
  }
}
