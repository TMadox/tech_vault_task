import '../../domain/entities/conversion_result.dart';

class ConversionModel extends ConversionResult {
  const ConversionModel({required super.fromCurrency, required super.toCurrency, required super.amount, required super.rate, required super.result});

  factory ConversionModel.fromRate(String fromCurrency, String toCurrency, double amount, double rate) {
    return ConversionModel(fromCurrency: fromCurrency, toCurrency: toCurrency, amount: amount, rate: rate, result: amount * rate);
  }
}
