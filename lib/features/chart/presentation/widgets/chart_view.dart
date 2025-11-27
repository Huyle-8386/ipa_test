import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/chart.dart';

class ChartView extends StatelessWidget {
  final List<Chart> data;

  const ChartView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    if (data.isEmpty) return const Center(child: CircularProgressIndicator());

    final maxIncome = data.map((e) => e.income).reduce((a, b) => a > b ? a : b);
    final maxExpense = data
        .map((e) => e.expense)
        .reduce((a, b) => a > b ? a : b);
    final maxValue = (maxIncome > maxExpense ? maxIncome : maxExpense);
    final interval = (maxValue / 3).ceilToDouble();
    final double safeInterval = interval == 0 ? 1.0 : interval;
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    final month = monthNames[now.month - 1];
    final year = now.year;
    final currentDate = "$day $month $year";

    return Container(
      width: w * 0.9,
      height: h * 0.25,
      padding: EdgeInsets.fromLTRB(w * 0.02, w * 0.01, w * 0.05, w * 0.01),
      decoration: BoxDecoration(
        color: AppColors.widget,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            currentDate,
            style: AppTextStyles.heading2.copyWith(color: Colors.white),
          ),
          SizedBox(height: h * 0.015),
          Expanded(
            child: LineChart(
              LineChartData(
                backgroundColor: AppColors.widget,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: maxValue + interval,

                lineTouchData: LineTouchData(
                  enabled: true,
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          CurrencyFormatter.formatVNDWithSymbol(spot.y),
                          AppTextStyles.body2.copyWith(
                            color: spot.bar.color, // <= màu line
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),

                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      interval: safeInterval,
                      getTitlesWidget: (value, meta) {
                        return SizedBox(
                          width: w * 0.1,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              CurrencyFormatter.formatVNDWithSymbol(value),
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= data.length)
                          return const SizedBox();
                        return SizedBox(
                          width: w * 0.09, // tùy chỉnh
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              data[index].day,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  _buildLine(
                    data.map((e) => e.income).toList(),
                    AppColors.main,
                  ),
                  _buildLine(
                    data.map((e) => e.expense).toList(),
                    AppColors.brightOrange,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // LineChartBarData _buildLine(List<double> values, Color color) {
  //   return LineChartBarData(
  //     isCurved: true,
  //     color: color,
  //     barWidth: 3,
  //     belowBarData: BarAreaData(show: false),
  //     spots: List.generate(
  //       values.length,
  //       (i) => FlSpot(i.toDouble(), values[i]),
  //     ),
  //   );
  // }
  LineChartBarData _buildLine(List<double> values, Color color) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 3,
      spots: List.generate(
        values.length,
        (i) => FlSpot(i.toDouble(), values[i]),
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [color.withOpacity(0.4), color.withOpacity(0.0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
