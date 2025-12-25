import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_currency/features/currencies/presentation/widgets/currencies_listview.dart';

import '../../../../core/widgets/error_state_widget.dart';
import '../bloc/currencies_bloc.dart';
import '../bloc/currencies_event.dart';
import '../bloc/currencies_state.dart';

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
      appBar: AppBar(title: Text('currencies.title'.tr())),
      body: BlocBuilder<CurrenciesBloc, CurrenciesState>(
        builder: (context, state) {
          if (state is CurrenciesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CurrenciesError) {
            return ErrorStateWidget(
              title: 'error.loading_currencies'.tr(),
              message: state.message,
              onRetry: () =>
                  context.read<CurrenciesBloc>().add(const LoadCurrencies()),
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
