import 'package:equatable/equatable.dart';
import '../../domain/entities/conversion_result.dart';

abstract class ConverterState extends Equatable {
  const ConverterState();

  @override
  List<Object?> get props => [];
}

class ConverterInitial extends ConverterState {
  const ConverterInitial();
}

class ConverterLoading extends ConverterState {
  const ConverterLoading();
}

class ConverterSuccess extends ConverterState {
  final ConversionResult result;

  const ConverterSuccess({required this.result});

  @override
  List<Object?> get props => [result];
}

class ConverterError extends ConverterState {
  final String message;

  const ConverterError({required this.message});

  @override
  List<Object?> get props => [message];
}
