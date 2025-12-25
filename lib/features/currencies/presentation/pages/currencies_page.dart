import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
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
            return _buildErrorState(state.message);
          }

          if (state is CurrenciesLoaded) {
            return _buildCurrenciesList(state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: AppConstants.defaultPadding),
            Text('Error Loading Currencies', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.outline),
            ),
            const SizedBox(height: AppConstants.largePadding),
            FilledButton.icon(
              onPressed: () {
                context.read<CurrenciesBloc>().add(const LoadCurrencies());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrenciesList(CurrenciesLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CurrenciesBloc>().add(const LoadCurrencies());
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
        itemCount: state.currencies.length,
        itemBuilder: (context, index) {
          final currency = state.currencies[index];
          return CurrencyListTile(currency: currency);
        },
      ),
    );
  }
}
