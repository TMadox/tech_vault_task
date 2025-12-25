import 'package:equatable/equatable.dart';

abstract class HistoricalEvent extends Equatable {
  const HistoricalEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistoricalRates extends HistoricalEvent {
  const LoadHistoricalRates();
}
