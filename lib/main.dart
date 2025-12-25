import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:task_currency/shell.dart';

import 'core/constants/app_constants.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/converter/presentation/bloc/converter_bloc.dart';
import 'features/currencies/presentation/bloc/currencies_bloc.dart';
import 'features/historical/presentation/bloc/historical_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrenciesBloc>(create: (_) => getIt<CurrenciesBloc>()),
        BlocProvider<HistoricalBloc>(create: (_) => getIt<HistoricalBloc>()),
        BlocProvider<ConverterBloc>(create: (_) => getIt<ConverterBloc>()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const MainNavigation(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FormBuilderLocalizations.delegate,
        ],
      ),
    );
  }
}
