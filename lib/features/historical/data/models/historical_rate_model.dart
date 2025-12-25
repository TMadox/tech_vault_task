import '../../../../core/database/app_database.dart';
import '../../domain/entities/historical_rate.dart';

class HistoricalRateModel extends HistoricalRate {
  const HistoricalRateModel({required super.fromCurrency, required super.toCurrency, required super.date, required super.rate});

  factory HistoricalRateModel.fromJson(String fromCurrency, String toCurrency, String dateString, double rate) {
    return HistoricalRateModel(fromCurrency: fromCurrency, toCurrency: toCurrency, date: DateTime.parse(dateString), rate: rate);
  }

  factory HistoricalRateModel.fromTableData(HistoricalRatesTableData data) {
    return HistoricalRateModel(fromCurrency: data.fromCurrency, toCurrency: data.toCurrency, date: data.date, rate: data.rate);
  }

  HistoricalRatesTableCompanion toCompanion() {
    return HistoricalRatesTableCompanion.insert(fromCurrency: fromCurrency, toCurrency: toCurrency, date: date, rate: rate);
  }
}
