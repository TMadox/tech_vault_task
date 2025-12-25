import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_currency/features/historical/domain/entities/historical_rate.dart';

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
      appBar: AppBar(title: Text('historical.title'.tr())),
      body: BlocBuilder<HistoricalBloc, HistoricalState>(
        builder: (context, state) => switch (state) {
          HistoricalLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          HistoricalError(message: String message) => ErrorStateWidget(
            title: 'error.loading_data'.tr(),
            message: message,
            onRetry: () =>
                context.read<HistoricalBloc>().add(const LoadHistoricalRates()),
          ),
          HistoricalLoaded(
            rates: List<HistoricalRate> rates,
            fromCurrency: String fromCurrency,
            toCurrency: String toCurrency,
          ) =>
            HistoricalChart(
              rates: rates,
              toCurrency: toCurrency,
              fromCurrency: fromCurrency,
            ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
