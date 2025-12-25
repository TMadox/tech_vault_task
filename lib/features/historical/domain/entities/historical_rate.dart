import 'package:equatable/equatable.dart';

class HistoricalRate extends Equatable {
  final String fromCurrency;
  final String toCurrency;
  final DateTime date;
  final double rate;

  const HistoricalRate({required this.fromCurrency, required this.toCurrency, required this.date, required this.rate});

  @override
  List<Object?> get props => [fromCurrency, toCurrency, date, rate];
}
