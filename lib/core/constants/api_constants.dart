abstract class ApiConstants {
  static const String baseUrl = 'https://v6.exchangerate-api.com/v6';
  static const String apiKey = '14b41a91b6614f960222aaf2';

  static String latestRates(String baseCurrency) => '$baseUrl/$apiKey/latest/$baseCurrency';

  static String pairConversion(String from, String to, double amount) => '$baseUrl/$apiKey/pair/$from/$to/$amount';

  static String supportedCodes() => '$baseUrl/$apiKey/codes';
}
