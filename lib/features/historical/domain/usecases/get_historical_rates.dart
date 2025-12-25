import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/historical_rate.dart';
import '../repositories/historical_repository.dart';

@lazySingleton
class GetHistoricalRates implements UseCase<List<HistoricalRate>, HistoricalRatesParams> {
  final HistoricalRepository _repository;

  GetHistoricalRates(this._repository);

  @override
  Future<Either<Failure, List<HistoricalRate>>> call(HistoricalRatesParams params) {
    return _repository.getHistoricalRates(params.fromCurrency, params.toCurrency, params.startDate, params.endDate);
  }
}

class HistoricalRatesParams extends Equatable {
  final String fromCurrency;
  final String toCurrency;
  final DateTime startDate;
  final DateTime endDate;

  const HistoricalRatesParams({required this.fromCurrency, required this.toCurrency, required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [fromCurrency, toCurrency, startDate, endDate];
}
