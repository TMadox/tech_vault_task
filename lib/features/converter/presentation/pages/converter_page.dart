import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../currencies/domain/entities/currency.dart';
import '../../../currencies/presentation/bloc/currencies_bloc.dart';
import '../../../currencies/presentation/bloc/currencies_event.dart';
import '../../../currencies/presentation/bloc/currencies_state.dart';
import '../bloc/converter_bloc.dart';
import '../bloc/converter_event.dart';
import '../bloc/converter_state.dart';
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
            return _buildCurrenciesError(currenciesState.message);
          }

          if (currenciesState is CurrenciesLoaded) {
            return _buildConverterForm(currenciesState.currencies);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCurrenciesError(String message) => Center(
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
            onPressed: () => context.read<CurrenciesBloc>().add(const LoadCurrencies()),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    ),
  );

  Widget _buildConverterForm(List<Currency> currencies) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppConstants.defaultPadding),
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CurrencyDropdown(
            currencies: currencies,
            selectedCurrency: _fromCurrency,
            onChanged: (currency) {
              setState(() => _fromCurrency = currency);
              context.read<ConverterBloc>().add(const ResetConverter());
            },
            label: 'From Currency',
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Center(
            child: IconButton.filled(onPressed: _swapCurrencies, icon: const Icon(Icons.swap_vert)),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          CurrencyDropdown(
            currencies: currencies,
            selectedCurrency: _toCurrency,
            onChanged: (currency) {
              setState(() {
                _toCurrency = currency;
              });
              context.read<ConverterBloc>().add(const ResetConverter());
            },
            label: 'To Currency',
          ),
          const SizedBox(height: AppConstants.largePadding),
          TextFormField(
            controller: _amountController,
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
            onChanged: (_) {
              context.read<ConverterBloc>().add(const ResetConverter());
            },
          ),
          const SizedBox(height: AppConstants.largePadding),
          FilledButton.icon(onPressed: _convert, icon: const Icon(Icons.currency_exchange), label: const Text('Convert')),
          const SizedBox(height: AppConstants.largePadding),
          BlocBuilder<ConverterBloc, ConverterState>(
            builder: (context, state) {
              if (state is ConverterLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ConverterError) {
                return Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onErrorContainer),
                        const SizedBox(width: AppConstants.smallPadding),
                        Expanded(
                          child: Text(state.message, style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer)),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is ConverterSuccess) {
                return _buildResultCard(state);
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    ),
  );

  Widget _buildResultCard(ConverterSuccess state) {
    final result = state.result;
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          children: [
            Text('${result.amount.toStringAsFixed(2)} ${result.fromCurrency}', style: Theme.of(context).textTheme.titleMedium),
            Icon(Icons.arrow_downward, color: Theme.of(context).colorScheme.onPrimaryContainer),
            Text(
              '${result.result.toStringAsFixed(4)} ${result.toCurrency}',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'Rate: 1 ${result.fromCurrency} = ${result.rate.toStringAsFixed(6)} ${result.toCurrency}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7)),
            ),
          ],
        ),
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
