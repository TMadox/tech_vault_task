import 'package:task_currency/core/config/env.dart';

abstract class ApiConstants {
  static const String baseUrl = 'https://v6.exchangerate-api.com/v6';
  //Notice that i used env for security, but since we are not using ci/cd, the Api key is 
  static String get apiKey => Env.apiKey;

  static String latestRates(String baseCurrency) =>
      '$baseUrl/$apiKey/latest/$baseCurrency';

  static String pairConversion(String from, String to, double amount) =>
      '$baseUrl/$apiKey/pair/$from/$to/$amount';

  static String supportedCodes() => '$baseUrl/$apiKey/codes';
}
