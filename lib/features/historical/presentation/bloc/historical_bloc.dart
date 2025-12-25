import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/usecases/get_historical_rates.dart';
import 'historical_event.dart';
import 'historical_state.dart';

@injectable
class HistoricalBloc extends Bloc<HistoricalEvent, HistoricalState> {
  final GetHistoricalRates _getHistoricalRates;

  HistoricalBloc(this._getHistoricalRates) : super(const HistoricalInitial()) {
    on<LoadHistoricalRates>(_onLoadHistoricalRates);
  }

  Future<void> _onLoadHistoricalRates(LoadHistoricalRates event, Emitter<HistoricalState> emit) async {
    emit(const HistoricalLoading());

    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: AppConstants.historicalDays - 1));

    final result = await _getHistoricalRates(
      HistoricalRatesParams(
        fromCurrency: AppConstants.historicalFromCurrency,
        toCurrency: AppConstants.historicalToCurrency,
        startDate: startDate,
        endDate: endDate,
      ),
    );

    result.fold(
      (failure) => emit(HistoricalError(message: failure.message)),
      (rates) =>
          emit(HistoricalLoaded(rates: rates, fromCurrency: AppConstants.historicalFromCurrency, toCurrency: AppConstants.historicalToCurrency)),
    );
  }
}
