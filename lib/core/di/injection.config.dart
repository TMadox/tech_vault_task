// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/converter/data/datasources/converter_remote_datasource.dart'
    as _i405;
import '../../features/converter/data/repositories/converter_repository_impl.dart'
    as _i516;
import '../../features/converter/domain/repositories/converter_repository.dart'
    as _i908;
import '../../features/converter/domain/usecases/convert_currency.dart'
    as _i737;
import '../../features/converter/presentation/bloc/converter_bloc.dart'
    as _i358;
import '../../features/currencies/data/datasources/currencies_local_datasource.dart'
    as _i383;
import '../../features/currencies/data/datasources/currencies_remote_datasource.dart'
    as _i816;
import '../../features/currencies/data/repositories/currencies_repository_impl.dart'
    as _i148;
import '../../features/currencies/domain/repositories/currencies_repository.dart'
    as _i505;
import '../../features/currencies/domain/usecases/get_currencies.dart' as _i126;
import '../../features/currencies/presentation/bloc/currencies_bloc.dart'
    as _i171;
import '../../features/historical/data/datasources/historical_local_datasource.dart'
    as _i359;
import '../../features/historical/data/datasources/historical_remote_datasource.dart'
    as _i605;
import '../../features/historical/data/repositories/historical_repository_impl.dart'
    as _i664;
import '../../features/historical/domain/repositories/historical_repository.dart'
    as _i90;
import '../../features/historical/domain/usecases/get_historical_rates.dart'
    as _i24;
import '../../features/historical/presentation/bloc/historical_bloc.dart'
    as _i627;
import '../database/app_database.dart' as _i982;
import '../network/dio_client.dart' as _i667;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i982.AppDatabase>(() => _i982.AppDatabase());
    gh.lazySingleton<_i667.DioClient>(() => _i667.DioClient());
    gh.lazySingleton<_i816.CurrenciesRemoteDataSource>(
      () => _i816.CurrenciesRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i383.CurrenciesLocalDataSource>(
      () => _i383.CurrenciesLocalDataSourceImpl(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i405.ConverterRemoteDataSource>(
      () => _i405.ConverterRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i908.ConverterRepository>(
      () =>
          _i516.ConverterRepositoryImpl(gh<_i405.ConverterRemoteDataSource>()),
    );
    gh.lazySingleton<_i605.HistoricalRemoteDataSource>(
      () => _i605.HistoricalRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i359.HistoricalLocalDataSource>(
      () => _i359.HistoricalLocalDataSourceImpl(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i505.CurrenciesRepository>(
      () => _i148.CurrenciesRepositoryImpl(
        gh<_i816.CurrenciesRemoteDataSource>(),
        gh<_i383.CurrenciesLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i126.GetCurrencies>(
      () => _i126.GetCurrencies(gh<_i505.CurrenciesRepository>()),
    );
    gh.lazySingleton<_i737.ConvertCurrency>(
      () => _i737.ConvertCurrency(gh<_i908.ConverterRepository>()),
    );
    gh.factory<_i358.ConverterBloc>(
      () => _i358.ConverterBloc(gh<_i737.ConvertCurrency>()),
    );
    gh.factory<_i171.CurrenciesBloc>(
      () => _i171.CurrenciesBloc(gh<_i126.GetCurrencies>()),
    );
    gh.lazySingleton<_i90.HistoricalRepository>(
      () => _i664.HistoricalRepositoryImpl(
        gh<_i605.HistoricalRemoteDataSource>(),
        gh<_i359.HistoricalLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i24.GetHistoricalRates>(
      () => _i24.GetHistoricalRates(gh<_i90.HistoricalRepository>()),
    );
    gh.factory<_i627.HistoricalBloc>(
      () => _i627.HistoricalBloc(gh<_i24.GetHistoricalRates>()),
    );
    return this;
  }
}
