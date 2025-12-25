import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/currency.dart';

class CurrencyModel extends Currency {
  const CurrencyModel({required super.id, required super.currencyName, super.currencySymbol, super.countryCode});

  factory CurrencyModel.fromJson(String id, Map<String, dynamic> json) {
    return CurrencyModel(
      id: id,
      currencyName: json['currencyName'] as String? ?? '',
      currencySymbol: json['currencySymbol'] as String?,
      countryCode: _extractCountryCode(id),
    );
  }

  factory CurrencyModel.fromTableData(CurrenciesTableData data) {
    return CurrencyModel(id: data.id, currencyName: data.currencyName, currencySymbol: data.currencySymbol, countryCode: data.countryCode);
  }

  CurrenciesTableCompanion toCompanion() {
    return CurrenciesTableCompanion.insert(
      id: id,
      currencyName: currencyName,
      currencySymbol: Value(currencySymbol),
      countryCode: Value(countryCode),
    );
  }

  static String? _extractCountryCode(String currencyId) {
    if (currencyId.length >= 2) {
      return currencyId.substring(0, 2).toLowerCase();
    }
    return null;
  }
}
