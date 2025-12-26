import 'package:task_currency/core/config/env.dart';

abstract class ApiConstants {
  static const String baseUrl = 'https://v6.exchangerate-api.com/v6';
  // Notice that I used env for security and the env file is not pushed.
  // Since we are not using CI/CD, the API key is 14b41a91b6614f960222aaf2
  static String get apiKey => Env.apiKey;

  static String latestRates(String baseCurrency) =>
      '$baseUrl/$apiKey/latest/$baseCurrency';

  static String pairConversion(String from, String to, double amount) =>
      '$baseUrl/$apiKey/pair/$from/$to/$amount';

  static String supportedCodes() => '$baseUrl/$apiKey/codes';
}
