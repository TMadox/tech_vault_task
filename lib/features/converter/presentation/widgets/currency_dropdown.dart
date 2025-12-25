import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../currencies/domain/entities/currency.dart';

class CurrencyDropdown extends StatelessWidget {
  final List<Currency> currencies;
  final String name;
  final ValueChanged<Currency?>? onChanged;
  final String label;

  const CurrencyDropdown({
    super.key,
    required this.currencies,
    required this.name,
    this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        FormBuilderSearchableDropdown<Currency>(
          name: name,
          items: currencies,
          compareFn: (item1, item2) => item1.id == item2.id,
          itemAsString: (item) => '${item.id} - ${item.currencyName}',
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: AppConstants.smallPadding,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: 'converter.search_hint'.tr(),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            itemBuilder: (context, currency, isDisabled, isSelected) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: AppConstants.smallPadding,
              ),
              child: Row(
                children: [
                  _buildFlag(currency),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: Text(
                      '${currency.id} - ${currency.currencyName}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected) const Icon(Icons.check, size: 16),
                ],
              ),
            ),
          ),
          dropdownBuilder: (context, currency) {
            if (currency == null) {
              return const SizedBox.shrink();
            }
            return Row(
              children: [
                _buildFlag(currency),
                const SizedBox(width: AppConstants.smallPadding),
                Expanded(
                  child: Text(
                    '${currency.id} - ${currency.currencyName}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
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
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(2),
        ),
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
        placeholder: (context, url) =>
            Container(width: 24, height: 18, color: Colors.grey.shade200),
        errorWidget: (context, url, error) => Container(
          width: 24,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(2),
          ),
          child: const Icon(Icons.flag, size: 12),
        ),
      ),
    );
  }
}
