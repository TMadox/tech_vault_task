import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'features/converter/presentation/pages/converter_page.dart';
import 'features/currencies/presentation/pages/currencies_page.dart';
import 'features/historical/presentation/pages/historical_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ConverterPage(),
    CurrenciesPage(),
    HistoricalPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.currency_exchange_outlined),
            selectedIcon: Icon(Icons.currency_exchange),
            label: 'navigation.converter'.tr(context: context),
          ),
          NavigationDestination(
            icon: Icon(Icons.list_outlined),
            selectedIcon: Icon(Icons.list),
            label: 'navigation.currencies'.tr(context: context),
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: 'navigation.historical'.tr(context: context),
          ),
        ],
      ),
    );
  }
}
