import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/historical_rate.dart';
import '../../domain/repositories/historical_repository.dart';
import '../datasources/historical_local_datasource.dart';
import '../datasources/historical_remote_datasource.dart';

@LazySingleton(as: HistoricalRepository)
class HistoricalRepositoryImpl implements HistoricalRepository {
  final HistoricalRemoteDataSource _remoteDataSource;
  final HistoricalLocalDataSource _localDataSource;

  HistoricalRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, List<HistoricalRate>>> getHistoricalRates(
    String fromCurrency,
    String toCurrency,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final hasCached = await _localDataSource.hasCachedRates(fromCurrency, toCurrency, startDate, endDate);

      if (hasCached) {
        final rates = await _localDataSource.getHistoricalRates(fromCurrency, toCurrency, startDate, endDate);
        return Right(rates);
      }

      final remoteRates = await _remoteDataSource.getHistoricalRates(fromCurrency, toCurrency, startDate, endDate);
      await _localDataSource.cacheHistoricalRates(remoteRates);
      return Right(remoteRates);
    } on ServerException catch (e) {
      try {
        final rates = await _localDataSource.getHistoricalRates(fromCurrency, toCurrency, startDate, endDate);
        if (rates.isNotEmpty) {
          return Right(rates);
        }
      } catch (_) {}
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
