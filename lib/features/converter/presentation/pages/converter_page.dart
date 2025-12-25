import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:task_currency/features/converter/presentation/widgets/converter_form_content.dart';

import '../../../../core/widgets/error_state_widget.dart';
import '../../../currencies/domain/entities/currency.dart';
import '../../../currencies/presentation/bloc/currencies_bloc.dart';
import '../../../currencies/presentation/bloc/currencies_event.dart';
import '../../../currencies/presentation/bloc/currencies_state.dart';
import '../bloc/converter_bloc.dart';
import '../bloc/converter_event.dart';

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    final currenciesState = context.read<CurrenciesBloc>().state;
    if (currenciesState is! CurrenciesLoaded) {
      context.read<CurrenciesBloc>().add(const LoadCurrencies());
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('converter.title'.tr()),
        actions: [
          IconButton(
            onPressed: () {
              if (context.locale.languageCode == 'en') {
                context.setLocale(const Locale('ar'));
              } else {
                context.setLocale(const Locale('en'));
              }
            },
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      body: BlocBuilder<CurrenciesBloc, CurrenciesState>(
        builder: (context, currenciesState) {
          if (currenciesState is CurrenciesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (currenciesState is CurrenciesError) {
            return ErrorStateWidget(
              title: 'error.loading_currencies'.tr(),
              message: currenciesState.message,
              onRetry: () =>
                  context.read<CurrenciesBloc>().add(const LoadCurrencies()),
            );
          }

          if (currenciesState is CurrenciesLoaded) {
            return ConverterFormContent(
              formKey: _formKey,
              onConvert: _convert,
              onSwapCurrencies: _swapCurrencies,
              amountController: _amountController,
              currencies: currenciesState.currencies,
              onFromCurrencyChanged: (currency) =>
                  context.read<ConverterBloc>().add(const ResetConverter()),
              onToCurrencyChanged: (currency) =>
                  context.read<ConverterBloc>().add(const ResetConverter()),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _swapCurrencies() {
    _formKey.currentState!.save();
    final currencyFrom = _formKey.currentState!.value['from_currency'];
    final currencyTo = _formKey.currentState!.value['to_currency'];
    _formKey.currentState!.patchValue({
      'from_currency': currencyTo,
      'to_currency': currencyFrom,
    });
    context.read<ConverterBloc>().add(const ResetConverter());
  }

  void _convert() {
    if (_formKey.currentState!.saveAndValidate()) {
      final amount = double.parse(_formKey.currentState!.value['amount']);
      final fromCurrency =
          _formKey.currentState!.value['from_currency'] as Currency;
      final toCurrency =
          _formKey.currentState!.value['to_currency'] as Currency;
      context.read<ConverterBloc>().add(
        ConvertCurrencyEvent(
          fromCurrency: fromCurrency.id,
          toCurrency: toCurrency.id,
          amount: amount,
        ),
      );
    }
  }
}
