import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../currencies/domain/entities/currency.dart';

class CurrencyDropdown extends StatelessWidget {
  final List<Currency> currencies;
  final Currency? selectedCurrency;
  final ValueChanged<Currency?> onChanged;
  final String label;

  const CurrencyDropdown({super.key, required this.currencies, required this.selectedCurrency, required this.onChanged, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: AppConstants.smallPadding),
        DropdownButtonFormField<Currency>(
          value: selectedCurrency,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding, vertical: AppConstants.smallPadding),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
          ),
          items: currencies.map((currency) {
            return DropdownMenuItem<Currency>(
              value: currency,
              child: Row(
                children: [
                  _buildFlag(currency),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(child: Text('${currency.id} - ${currency.currencyName}', overflow: TextOverflow.ellipsis)),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
          selectedItemBuilder: (context) {
            return currencies.map((currency) {
              return Row(
                children: [
                  _buildFlag(currency),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(child: Text('${currency.id} - ${currency.currencyName}', overflow: TextOverflow.ellipsis)),
                ],
              );
            }).toList();
          },
        ),
      ],
    );
  }

  Widget _buildFlag(Currency currency) {
    if (currency.countryCode == null) {
      return Container(
        width: 24,
        height: 18,
        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(2)),
        child: const Icon(Icons.flag, size: 12),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: CachedNetworkImage(
        imageUrl: AppConstants.getFlagUrl(currency.countryCode!),
        width: 24,
        height: 18,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(width: 24, height: 18, color: Colors.grey.shade200),
        errorWidget: (context, url, error) => Container(
          width: 24,
          height: 18,
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(2)),
          child: const Icon(Icons.flag, size: 12),
        ),
      ),
    );
  }
}
