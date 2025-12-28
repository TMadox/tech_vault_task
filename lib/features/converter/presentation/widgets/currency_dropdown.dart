import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_image_loader.dart';
import '../../../currencies/domain/entities/currency.dart';

class CurrencyDropdown extends StatelessWidget {
  final List<Currency> currencies;
  final String name;
  final bool Function(Currency)? disabledItemFn;
  final ValueChanged<Currency?>? onChanged;
  final String label;

  const CurrencyDropdown({
    super.key,
    required this.currencies,
    required this.name,
    this.disabledItemFn,
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
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
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
            disabledItemFn: disabledItemFn,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: 'converter.search_hint'.tr(),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            itemBuilder: (context, currency, isDisabled, isSelected) => Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.smallPadding,
                horizontal: AppConstants.defaultPadding,
              ),
              child: Row(
                children: [
                  _buildFlag(currency),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: Text(
                      '${currency.id} - ${currency.currencyName}',
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: isDisabled
                            ? context.colorScheme.onSurface.withValues(
                                alpha: 0.38,
                              )
                            : isSelected
                            ? context.colorScheme.primary
                            : context.colorScheme.onSurfaceVariant,
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
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
    return AppImageLoader(
      imageUrl: AppConstants.getFlagUrl(currency.countryCode!),
      width: 24,
      height: 18,
      fit: BoxFit.cover,
      borderRadius: 2,
      placeholder: Container(
        width: 24,
        height: 18,
        color: Colors.grey.shade200,
      ),
      errorWidget: Container(
        width: 24,
        height: 18,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(2),
        ),
        child: const Icon(Icons.flag, size: 12),
      ),
    );
  }
}
