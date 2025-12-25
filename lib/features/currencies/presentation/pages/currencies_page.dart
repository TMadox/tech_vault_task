import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../bloc/currencies_bloc.dart';
import '../bloc/currencies_event.dart';
import '../bloc/currencies_state.dart';
import '../widgets/currency_list_tile.dart';

class CurrenciesPage extends StatefulWidget {
  const CurrenciesPage({super.key});

  @override
  State<CurrenciesPage> createState() => _CurrenciesPageState();
}

class _CurrenciesPageState extends State<CurrenciesPage> {
  @override
  void initState() {
    super.initState();
    context.read<CurrenciesBloc>().add(const LoadCurrencies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currencies')),
      body: BlocBuilder<CurrenciesBloc, CurrenciesState>(
        builder: (context, state) {
          if (state is CurrenciesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CurrenciesError) {
            return ErrorStateWidget(
              title: 'Error Loading Currencies',
              message: state.message,
              onRetry: () => context.read<CurrenciesBloc>().add(const LoadCurrencies()),
            );
          }

          if (state is CurrenciesLoaded) {
            return CurrenciesListView(currencies: state.currencies);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class CurrenciesListView extends StatelessWidget {
  final List currencies;

  const CurrenciesListView({super.key, required this.currencies});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CurrenciesBloc>().add(const LoadCurrencies());
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
        itemCount: currencies.length,
        itemBuilder: (context, index) {
          final currency = currencies[index];
          return CurrencyListTile(currency: currency);
        },
      ),
    );
  }
}
