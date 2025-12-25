import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/historical_bloc.dart';
import '../bloc/historical_event.dart';
import '../bloc/historical_state.dart';
import '../widgets/historical_chart.dart';

class HistoricalPage extends StatefulWidget {
  const HistoricalPage({super.key});

  @override
  State<HistoricalPage> createState() => _HistoricalPageState();
}

class _HistoricalPageState extends State<HistoricalPage> {
  @override
  void initState() {
    super.initState();
    context.read<HistoricalBloc>().add(const LoadHistoricalRates());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historical Rates')),
      body: BlocBuilder<HistoricalBloc, HistoricalState>(
        builder: (context, state) {
          if (state is HistoricalLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HistoricalError) {
            return _buildErrorState(state.message);
          }

          if (state is HistoricalLoaded) {
            return HistoricalChart(rates: state.rates, fromCurrency: state.fromCurrency, toCurrency: state.toCurrency);
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
            Text('Error Loading Data', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.outline),
            ),
            const SizedBox(height: AppConstants.largePadding),
            FilledButton.icon(
              onPressed: () {
                context.read<HistoricalBloc>().add(const LoadHistoricalRates());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
