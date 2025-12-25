import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/convert_currency.dart';
import 'converter_event.dart';
import 'converter_state.dart';

@injectable
class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {
  final ConvertCurrency _convertCurrency;

  ConverterBloc(this._convertCurrency) : super(const ConverterInitial()) {
    on<ConvertCurrencyEvent>(_onConvertCurrency);
    on<ResetConverter>(_onResetConverter);
  }

  Future<void> _onConvertCurrency(ConvertCurrencyEvent event, Emitter<ConverterState> emit) async {
    emit(const ConverterLoading());

    final result = await _convertCurrency(
      ConvertCurrencyParams(fromCurrency: event.fromCurrency, toCurrency: event.toCurrency, amount: event.amount),
    );

    result.fold((failure) => emit(ConverterError(message: failure.message)), (conversion) => emit(ConverterSuccess(result: conversion)));
  }

  void _onResetConverter(ResetConverter event, Emitter<ConverterState> emit) {
    emit(const ConverterInitial());
  }
}
