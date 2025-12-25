import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/historical_rate.dart';

abstract class HistoricalRepository {
  Future<Either<Failure, List<HistoricalRate>>> getHistoricalRates(String fromCurrency, String toCurrency, DateTime startDate, DateTime endDate);
}
