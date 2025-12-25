import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/conversion_result.dart';

class ConversionResultCard extends StatelessWidget {
  final ConversionResult result;

  const ConversionResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          children: [
            Text(
              '${result.amount.toStringAsFixed(2)} ${result.fromCurrency}',
              style: context.textTheme.titleMedium,
            ),
            Icon(
              Icons.arrow_downward,
              color: context.colorScheme.onPrimaryContainer,
            ),
            Text(
              '${result.result.toStringAsFixed(4)} ${result.toCurrency}',
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'Rate: 1 ${result.fromCurrency} = ${result.rate.toStringAsFixed(6)} ${result.toCurrency}',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onPrimaryContainer.withAlpha(179),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
