import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/conversion_result.dart';
import '../../domain/repositories/converter_repository.dart';
import '../datasources/converter_remote_datasource.dart';

@LazySingleton(as: ConverterRepository)
class ConverterRepositoryImpl implements ConverterRepository {
  final ConverterRemoteDataSource _remoteDataSource;

  ConverterRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ConversionResult>> convertCurrency(String fromCurrency, String toCurrency, double amount) async {
    try {
      final result = await _remoteDataSource.convertCurrency(fromCurrency, toCurrency, amount);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
