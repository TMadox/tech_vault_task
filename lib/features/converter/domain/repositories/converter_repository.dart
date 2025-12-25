import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/conversion_result.dart';

abstract class ConverterRepository {
  Future<Either<Failure, ConversionResult>> convertCurrency(String fromCurrency, String toCurrency, double amount);
}
