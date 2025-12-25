import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../currencies/domain/entities/currency.dart';
import '../../../currencies/presentation/bloc/currencies_bloc.dart';
import '../../../currencies/presentation/bloc/currencies_event.dart';
import '../../../currencies/presentation/bloc/currencies_state.dart';
import '../bloc/converter_bloc.dart';
import '../bloc/converter_event.dart';
import '../bloc/converter_state.dart';
import '../widgets/conversion_result_card.dart';
import '../widgets/currency_dropdown.dart';

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
      appBar: AppBar(title: Text('converter.title'.tr())),
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
              currencies: currenciesState.currencies,
              amountController: _amountController,
              formKey: _formKey,
              onConvert: _convert,
              onSwapCurrencies: _swapCurrencies,
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

class ConverterFormContent extends StatelessWidget {
  final List<Currency> currencies;
  final TextEditingController amountController;
  final GlobalKey<FormBuilderState> formKey;

  final ValueChanged<Currency?> onFromCurrencyChanged;
  final ValueChanged<Currency?> onToCurrencyChanged;
  final VoidCallback onSwapCurrencies;
  final VoidCallback onConvert;

  const ConverterFormContent({
    super.key,
    required this.currencies,
    required this.amountController,
    required this.formKey,
    required this.onFromCurrencyChanged,
    required this.onToCurrencyChanged,
    required this.onSwapCurrencies,
    required this.onConvert,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: FormBuilder(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CurrencyDropdown(
              currencies: currencies,
              name: 'from_currency',
              onChanged: (currency) {
                // Schedule state update to avoid "widget tree locked" errors
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    onFromCurrencyChanged(currency);
                  }
                });
              },
              label: 'From Currency',
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Center(
              child: IconButton.filled(
                onPressed: onSwapCurrencies,
                icon: const Icon(Icons.swap_vert),
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            CurrencyDropdown(
              currencies: currencies,
              name: 'to_currency',
              onChanged: (currency) {
                // Schedule state update to avoid "widget tree locked" errors
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    onToCurrencyChanged(currency);
                  }
                });
              },
              label: 'To Currency',
            ),
            const SizedBox(height: AppConstants.largePadding),
            FormBuilderTextField(
              name: 'amount',
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              validator: (value) {
                if (formKey.currentState?.fields['from_currency']?.value ==
                    null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('validation.select_source'.tr())),
                  );
                  return 'validation.select_source'.tr();
                }

                if (formKey.currentState?.fields['to_currency']?.value ==
                    null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('validation.select_target'.tr())),
                  );
                  return 'validation.select_target'.tr();
                }

                if (value == null || value.isEmpty) {
                  return 'validation.enter_amount'.tr();
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'validation.valid_amount'.tr();
                }
                return null;
              },
              onChanged: (_) =>
                  context.read<ConverterBloc>().add(const ResetConverter()),
            ),
            const SizedBox(height: AppConstants.largePadding),
            FilledButton.icon(
              onPressed: onConvert,
              icon: const Icon(Icons.currency_exchange),
              label: const Text('Convert'),
            ),
            const SizedBox(height: AppConstants.largePadding),
            BlocBuilder<ConverterBloc, ConverterState>(
              builder: (context, state) {
                if (state is ConverterLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ConverterError) {
                  return ConverterErrorCard(message: state.message);
                }

                if (state is ConverterSuccess) {
                  return ConversionResultCard(result: state.result);
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ConverterErrorCard extends StatelessWidget {
  final String message;

  const ConverterErrorCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            const SizedBox(width: AppConstants.smallPadding),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
