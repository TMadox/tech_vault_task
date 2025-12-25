import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/currency.dart';

class CurrencyListTile extends StatelessWidget {
  final Currency currency;
  final VoidCallback? onTap;

  const CurrencyListTile({super.key, required this.currency, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding / 2,
      ),
      child: ListTile(
        leading: _buildFlag(),
        title: Text(
          currency.currencyName,
          style: context.textTheme.titleMedium,
        ),
        subtitle: Text(
          currency.id,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
        trailing: currency.currencySymbol != null
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.smallPadding,
                  vertical: AppConstants.smallPadding / 2,
                ),
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius / 2,
                  ),
                ),
                child: Text(
                  currency.currencySymbol!,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.onPrimaryContainer,
                  ),
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildFlag() {
    if (currency.countryCode == null) {
      return Container(
        width: AppConstants.flagWidth,
        height: AppConstants.flagHeight,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.flag, size: 16),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CachedNetworkImage(
        imageUrl: AppConstants.getFlagUrl(currency.countryCode!),
        width: AppConstants.flagWidth,
        height: AppConstants.flagHeight,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: AppConstants.flagWidth,
          height: AppConstants.flagHeight,
          color: Colors.grey.shade200,
          child: const Center(
            child: SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: AppConstants.flagWidth,
          height: AppConstants.flagHeight,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.flag, size: 16),
        ),
      ),
    );
  }
}
