import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/error_state_widget.dart';
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
            return ErrorStateWidget(
              title: 'Error Loading Data',
              message: state.message,
              onRetry: () => context.read<HistoricalBloc>().add(const LoadHistoricalRates()),
            );
          }

          if (state is HistoricalLoaded) {
            return HistoricalChart(rates: state.rates, fromCurrency: state.fromCurrency, toCurrency: state.toCurrency);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
