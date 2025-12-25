import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_currency/core/constants/app_constants.dart';
import 'package:task_currency/features/currencies/presentation/bloc/currencies_bloc.dart';
import 'package:task_currency/features/currencies/presentation/bloc/currencies_event.dart';
import 'package:task_currency/features/currencies/presentation/widgets/currency_list_tile.dart';

class CurrenciesListView extends StatelessWidget {
  final List currencies;

  const CurrenciesListView({super.key, required this.currencies});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async =>
          context.read<CurrenciesBloc>().add(const LoadCurrencies()),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.smallPadding,
        ),
        itemCount: currencies.length,
        itemBuilder: (context, index) {
          final currency = currencies[index];
          return CurrencyListTile(currency: currency);
        },
      ),
    );
  }
}
