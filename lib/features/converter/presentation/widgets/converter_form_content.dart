import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:task_currency/features/converter/presentation/bloc/converter_bloc.dart';
import 'package:task_currency/features/converter/presentation/bloc/converter_event.dart';
import 'package:task_currency/features/converter/presentation/bloc/converter_state.dart';
import 'package:task_currency/features/converter/presentation/pages/converter_page.dart';
import 'package:task_currency/features/converter/presentation/widgets/conversion_result_card.dart';
import 'package:task_currency/features/converter/presentation/widgets/currency_dropdown.dart';
import 'package:task_currency/features/currencies/domain/entities/currency.dart';

import '../../../../core/constants/app_constants.dart';

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
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
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
