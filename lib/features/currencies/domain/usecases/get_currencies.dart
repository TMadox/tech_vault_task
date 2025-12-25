import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/currency.dart';
import '../repositories/currencies_repository.dart';

@lazySingleton
class GetCurrencies implements UseCase<List<Currency>, NoParams> {
  final CurrenciesRepository _repository;

  GetCurrencies(this._repository);

  @override
  Future<Either<Failure, List<Currency>>> call(NoParams params) {
    return _repository.getCurrencies();
  }
}
