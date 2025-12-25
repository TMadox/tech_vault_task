import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_currencies.dart';
import 'currencies_event.dart';
import 'currencies_state.dart';

@injectable
class CurrenciesBloc extends Bloc<CurrenciesEvent, CurrenciesState> {
  final GetCurrencies _getCurrencies;

  CurrenciesBloc(this._getCurrencies) : super(const CurrenciesInitial()) {
    on<LoadCurrencies>(_onLoadCurrencies);
  }

  Future<void> _onLoadCurrencies(LoadCurrencies event, Emitter<CurrenciesState> emit) async {
    emit(const CurrenciesLoading());

    final result = await _getCurrencies(const NoParams());

    result.fold((failure) => emit(CurrenciesError(message: failure.message)), (currencies) => emit(CurrenciesLoaded(currencies: currencies)));
  }
}
