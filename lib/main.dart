import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/currencies/presentation/bloc/currencies_bloc.dart';
import 'features/currencies/presentation/pages/currencies_page.dart';
import 'features/historical/presentation/bloc/historical_bloc.dart';
import 'features/historical/presentation/pages/historical_page.dart';
import 'features/converter/presentation/bloc/converter_bloc.dart';
import 'features/converter/presentation/pages/converter_page.dart';

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
      child: MaterialApp(title: AppConstants.appName, theme: AppTheme.lightTheme, debugShowCheckedModeBanner: false, home: const MainNavigation()),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [ConverterPage(), CurrenciesPage(), HistoricalPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.currency_exchange_outlined), selectedIcon: Icon(Icons.currency_exchange), label: 'Converter'),
          NavigationDestination(icon: Icon(Icons.list_outlined), selectedIcon: Icon(Icons.list), label: 'Currencies'),
          NavigationDestination(icon: Icon(Icons.show_chart_outlined), selectedIcon: Icon(Icons.show_chart), label: 'Historical'),
        ],
      ),
    );
  }
}
