abstract class ApiConstants {
  static const String baseUrl = 'https://free.currencyconverterapi.com';
  static const String apiVersion = 'api/v7';
  static const String apiKey = 'YOUR_API_KEY_HERE';

  static const String currenciesEndpoint = '$baseUrl/$apiVersion/currencies';
  static const String convertEndpoint = '$baseUrl/$apiVersion/convert';

  static String getCurrenciesUrl() => '$currenciesEndpoint?apiKey=$apiKey';

  static String getConvertUrl(String from, String to) => '$convertEndpoint?q=${from}_$to&compact=ultra&apiKey=$apiKey';

  static String getHistoricalUrl(String from, String to, String startDate, String endDate) =>
      '$convertEndpoint?q=${from}_$to&compact=ultra&date=$startDate&endDate=$endDate&apiKey=$apiKey';
}
