import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/localization/l10n.dart';

import 'core/constants/app_constants.dart';
import 'core/di/injection.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/converter/presentation/bloc/converter_bloc.dart';
import 'features/currencies/presentation/bloc/currencies_bloc.dart';
import 'features/historical/presentation/bloc/historical_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await configureDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const CurrencyConverterApp(),
    ),
  );
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
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates
          ..addAll([FormBuilderLocalizations.delegate]),
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}
