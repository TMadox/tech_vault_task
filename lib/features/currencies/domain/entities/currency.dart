import 'package:equatable/equatable.dart';

class Currency extends Equatable {
  final String id;
  final String currencyName;
  final String? currencySymbol;
  final String? countryCode;

  const Currency({required this.id, required this.currencyName, this.currencySymbol, this.countryCode});

  @override
  List<Object?> get props => [id, currencyName, currencySymbol, countryCode];
}
