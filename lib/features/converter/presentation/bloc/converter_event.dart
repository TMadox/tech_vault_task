import 'package:equatable/equatable.dart';

abstract class ConverterEvent extends Equatable {
  const ConverterEvent();

  @override
  List<Object?> get props => [];
}

class ConvertCurrencyEvent extends ConverterEvent {
  final String fromCurrency;
  final String toCurrency;
  final double amount;

  const ConvertCurrencyEvent({required this.fromCurrency, required this.toCurrency, required this.amount});

  @override
  List<Object?> get props => [fromCurrency, toCurrency, amount];
}

class SwapCurrencies extends ConverterEvent {
  const SwapCurrencies();
}

class ResetConverter extends ConverterEvent {
  const ResetConverter();
}
