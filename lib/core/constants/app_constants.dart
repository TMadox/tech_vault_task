import 'package:flutter/material.dart';

abstract class AppConstants {
  static const String appName = 'Currency Converter';

  static const String historicalFromCurrency = 'USD';
  static const String historicalToCurrency = 'KWD';
  static const int historicalDays = 7;

  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration apiTimeout = Duration(seconds: 30);

  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;

  static const double flagWidth = 32.0;
  static const double flagHeight = 24.0;

  static String getFlagUrl(String countryCode) => 'https://flagcdn.com/w80/${countryCode.toLowerCase()}.png';
}

abstract class AppColors {
  static const Color primary = Color(0xFF6750A4);
  static const Color secondary = Color(0xFF625B71);
  static const Color tertiary = Color(0xFF7D5260);
  static const Color error = Color(0xFFB3261E);
  static const Color surface = Color(0xFFFFFBFE);
  static const Color background = Color(0xFFFFFBFE);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onBackground = Color(0xFF1C1B1F);
  static const Color outline = Color(0xFF79747E);

  static const Color chartLine = Color(0xFF6750A4);
  static const Color chartFill = Color(0x336750A4);
  static const Color chartGrid = Color(0xFFE0E0E0);
}
