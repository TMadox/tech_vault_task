import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final _formKey = GlobalKey<FormState>();

  Currency? _fromCurrency;
  Currency? _toCurrency;

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
      appBar: AppBar(title: const Text('Currency Converter')),
      body: BlocBuilder<CurrenciesBloc, CurrenciesState>(
        builder: (context, currenciesState) {
          if (currenciesState is CurrenciesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (currenciesState is CurrenciesError) {
            return ErrorStateWidget(
              title: 'Error Loading Currencies',
              message: currenciesState.message,
              onRetry: () => context.read<CurrenciesBloc>().add(const LoadCurrencies()),
            );
          }

          if (currenciesState is CurrenciesLoaded) {
            return ConverterFormContent(
              currencies: currenciesState.currencies,
              amountController: _amountController,
              formKey: _formKey,
              fromCurrency: _fromCurrency,
              toCurrency: _toCurrency,
              onFromCurrencyChanged: (currency) {
                setState(() => _fromCurrency = currency);
                context.read<ConverterBloc>().add(const ResetConverter());
              },
              onToCurrencyChanged: (currency) {
                setState(() => _toCurrency = currency);
                context.read<ConverterBloc>().add(const ResetConverter());
              },
              onSwapCurrencies: _swapCurrencies,
              onConvert: _convert,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
    context.read<ConverterBloc>().add(const ResetConverter());
  }

  void _convert() {
    if (_fromCurrency == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a source currency')));
      return;
    }

    if (_toCurrency == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a target currency')));
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.parse(_amountController.text);

    context.read<ConverterBloc>().add(ConvertCurrencyEvent(fromCurrency: _fromCurrency!.id, toCurrency: _toCurrency!.id, amount: amount));
  }
}

class ConverterFormContent extends StatelessWidget {
  final List<Currency> currencies;
  final TextEditingController amountController;
  final GlobalKey<FormState> formKey;
  final Currency? fromCurrency;
  final Currency? toCurrency;
  final ValueChanged<Currency?> onFromCurrencyChanged;
  final ValueChanged<Currency?> onToCurrencyChanged;
  final VoidCallback onSwapCurrencies;
  final VoidCallback onConvert;

  const ConverterFormContent({
    super.key,
    required this.currencies,
    required this.amountController,
    required this.formKey,
    required this.fromCurrency,
    required this.toCurrency,
    required this.onFromCurrencyChanged,
    required this.onToCurrencyChanged,
    required this.onSwapCurrencies,
    required this.onConvert,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CurrencyDropdown(currencies: currencies, selectedCurrency: fromCurrency, onChanged: onFromCurrencyChanged, label: 'From Currency'),
            const SizedBox(height: AppConstants.defaultPadding),
            Center(
              child: IconButton.filled(onPressed: onSwapCurrencies, icon: const Icon(Icons.swap_vert)),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            CurrencyDropdown(currencies: currencies, selectedCurrency: toCurrency, onChanged: onToCurrencyChanged, label: 'To Currency'),
            const SizedBox(height: AppConstants.largePadding),
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
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
              onChanged: (_) => context.read<ConverterBloc>().add(const ResetConverter()),
            ),
            const SizedBox(height: AppConstants.largePadding),
            FilledButton.icon(onPressed: onConvert, icon: const Icon(Icons.currency_exchange), label: const Text('Convert')),
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
            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onErrorContainer),
            const SizedBox(width: AppConstants.smallPadding),
            Expanded(
              child: Text(message, style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer)),
            ),
          ],
        ),
      ),
    );
  }
}
