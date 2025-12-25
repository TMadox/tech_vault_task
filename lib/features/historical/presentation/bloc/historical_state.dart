import 'package:equatable/equatable.dart';
import '../../domain/entities/historical_rate.dart';

abstract class HistoricalState extends Equatable {
  const HistoricalState();

  @override
  List<Object?> get props => [];
}

class HistoricalInitial extends HistoricalState {
  const HistoricalInitial();
}

class HistoricalLoading extends HistoricalState {
  const HistoricalLoading();
}

class HistoricalLoaded extends HistoricalState {
  final List<HistoricalRate> rates;
  final String fromCurrency;
  final String toCurrency;

  const HistoricalLoaded({required this.rates, required this.fromCurrency, required this.toCurrency});

  @override
  List<Object?> get props => [rates, fromCurrency, toCurrency];
}

class HistoricalError extends HistoricalState {
  final String message;

  const HistoricalError({required this.message});

  @override
  List<Object?> get props => [message];
}
