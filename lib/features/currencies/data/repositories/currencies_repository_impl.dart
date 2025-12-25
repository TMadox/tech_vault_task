import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/currency.dart';
import '../../domain/repositories/currencies_repository.dart';
import '../datasources/currencies_local_datasource.dart';
import '../datasources/currencies_remote_datasource.dart';

@LazySingleton(as: CurrenciesRepository)
class CurrenciesRepositoryImpl implements CurrenciesRepository {
  final CurrenciesRemoteDataSource _remoteDataSource;
  final CurrenciesLocalDataSource _localDataSource;

  CurrenciesRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, List<Currency>>> getCurrencies() async {
    try {
      final hasCached = await _localDataSource.hasCachedCurrencies();

      if (hasCached) {
        final currencies = await _localDataSource.getCurrencies();
        return Right(currencies);
      }

      final remoteCurrencies = await _remoteDataSource.getCurrencies();
      await _localDataSource.cacheCurrencies(remoteCurrencies);
      return Right(remoteCurrencies);
    } on ServerException catch (e) {
      try {
        final hasCached = await _localDataSource.hasCachedCurrencies();
        if (hasCached) {
          final currencies = await _localDataSource.getCurrencies();
          return Right(currencies);
        }
      } catch (_) {}
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
