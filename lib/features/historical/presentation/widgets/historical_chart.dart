import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/historical_rate.dart';

class HistoricalChart extends StatelessWidget {
  final List<HistoricalRate> rates;
  final String fromCurrency;
  final String toCurrency;

  const HistoricalChart({
    super.key,
    required this.rates,
    required this.fromCurrency,
    required this.toCurrency,
  });

  @override
  Widget build(BuildContext context) {
    if (rates.isEmpty) {
      return Center(child: Text('historical.no_data'.tr()));
    }

    final spots = rates.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.rate);
    }).toList();

    final minY =
        rates.map((r) => r.rate).reduce((a, b) => a < b ? a : b) * 0.995;
    final maxY =
        rates.map((r) => r.rate).reduce((a, b) => a > b ? a : b) * 1.005;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'historical.conversion_title'.tr(args: [fromCurrency, toCurrency]),
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            'historical.last_days'.tr(args: [rates.length.toString()]),
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          const SizedBox(height: AppConstants.largePadding),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (maxY - minY) / 4,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: AppColors.chartGrid, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < rates.length) {
                          final date = rates[index].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              DateFormat(
                                'dd/MM',
                                context.locale.languageCode,
                              ).format(date),
                              style: context.textTheme.labelSmall,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) => Text(
                        value.toStringAsFixed(4),
                        style: context.textTheme.labelSmall,
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (rates.length - 1).toDouble(),
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.chartLine,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.chartLine,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.chartFill,
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                      final index = spot.x.toInt();
                      if (index >= 0 && index < rates.length) {
                        final date = rates[index].date;
                        return LineTooltipItem(
                          '${DateFormat('MMM dd', context.locale.languageCode).format(date)}\n${spot.y.toStringAsFixed(4)}',
                          const TextStyle(color: Colors.white),
                        );
                      }
                      return null;
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
