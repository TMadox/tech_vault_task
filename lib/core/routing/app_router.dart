import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/converter/presentation/pages/converter_page.dart';
import '../../features/currencies/presentation/pages/currencies_page.dart';
import '../../features/historical/presentation/pages/historical_page.dart';
import '../../shell.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorConverterKey =
    GlobalKey<NavigatorState>(debugLabel: 'converter');
final GlobalKey<NavigatorState> _shellNavigatorCurrenciesKey =
    GlobalKey<NavigatorState>(debugLabel: 'currencies');
final GlobalKey<NavigatorState> _shellNavigatorHistoricalKey =
    GlobalKey<NavigatorState>(debugLabel: 'historical');

class AppRouter {
  AppRouter._();
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.converter,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainNavigation(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorConverterKey,
            routes: [
              GoRoute(
                path: AppRoutes.converter,
                builder: (context, state) => const ConverterPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorCurrenciesKey,
            routes: [
              GoRoute(
                path: AppRoutes.currencies,
                builder: (context, state) => const CurrenciesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHistoricalKey,
            routes: [
              GoRoute(
                path: AppRoutes.historical,
                builder: (context, state) => const HistoricalPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
