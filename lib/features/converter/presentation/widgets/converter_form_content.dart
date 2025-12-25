import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:task_currency/core/widgets/error_state_widget.dart';
import 'package:task_currency/features/converter/presentation/bloc/converter_bloc.dart';
import 'package:task_currency/features/converter/presentation/bloc/converter_event.dart';
import 'package:task_currency/features/converter/presentation/bloc/converter_state.dart';
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
              onChanged: (currency) => onFromCurrencyChanged(currency),
              label: 'converter.from_currency'.tr(),
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
              onChanged: (currency) => onToCurrencyChanged(currency),
              label: 'converter.to_currency'.tr(),
            ),
            const SizedBox(height: AppConstants.largePadding),
            FormBuilderTextField(
              name: 'amount',
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'converter.amount'.tr(),
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
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: 'validation.enter_amount'.tr(),
                ),
                FormBuilderValidators.numeric(
                  errorText: 'validation.valid_amount'.tr(),
                ),
                FormBuilderValidators.notZeroNumber(
                  errorText: 'validation.valid_amount'.tr(),
                ),
              ]),
              onChanged: (_) =>
                  context.read<ConverterBloc>().add(const ResetConverter()),
            ),
            const SizedBox(height: AppConstants.largePadding),
            FilledButton.icon(
              onPressed: onConvert,
              icon: const Icon(Icons.currency_exchange),
              label: Text('converter.convert'.tr()),
            ),
            const SizedBox(height: AppConstants.largePadding),
            BlocBuilder<ConverterBloc, ConverterState>(
              builder: (context, state) {
                if (state is ConverterLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ConverterError) {
                  return ErrorStateWidget(
                    title: 'error'.tr(),
                    message: state.message,
                  );
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
