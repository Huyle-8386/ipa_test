// lib/features/budget/presentation/pages/widgets/line_chart_card.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';

class LineChartCard extends StatelessWidget {
  final List<double> spending;
  final List<double>? budgetLimit;
  final double h;
  final double w;

  const LineChartCard({
    super.key,
    required this.spending,
    required this.budgetLimit,
    required this.h,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    if (spending.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final maxSpend = spending.reduce((a, b) => a > b ? a : b);
    final maxBudget = (budgetLimit != null && budgetLimit!.isNotEmpty)
        ? budgetLimit!.reduce((a, b) => a > b ? a : b)
        : 0;
    final maxValue = (maxSpend > maxBudget ? maxSpend : maxBudget);
    final interval = (maxValue / 3).ceilToDouble();

    return Container(
      width: w * 0.9,
      height: h * 0.25,
      padding: EdgeInsets.fromLTRB(w * 0.02, w * 0.01, w * 0.05, w * 0.01),
      decoration: BoxDecoration(
        color: AppColors.widget,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Biểu đồ chính
          Expanded(
            child: LineChart(
              LineChartData(
                backgroundColor: AppColors.widget,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: maxValue + interval,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      interval: interval,
                      getTitlesWidget: (value, meta) => Text(
                        '\$${value.toInt()}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        const labels = [
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
                        if (index < 0 || index >= spending.length) {
                          return const SizedBox();
                        }
                        if (index % 2 != 0) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            labels[index],
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.grey,
                              fontSize: 12,
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
                  if (budgetLimit != null && budgetLimit!.isNotEmpty)
                    _buildLine(budgetLimit!, AppColors.main),
                  _buildLine(spending, AppColors.brightOrange),
                ],
              ),
            ),
          ),
          SizedBox(height: h * 0.01),
          // Chú thích
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(h, w, AppColors.main, "Budget"),
              SizedBox(width: w * 0.05),
              _buildLegendItem(h, w, AppColors.brightOrange, "Spent"),
            ],
          ),
        ],
      ),
    );
  }

  LineChartBarData _buildLine(List<double> values, Color color) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 3,
      belowBarData: BarAreaData(show: false),
      spots: List.generate(
        values.length,
        (i) => FlSpot(i.toDouble(), values[i]),
      ),
    );
  }

  Widget _buildLegendItem(double h, double w, Color color, String label) {
    return Row(
      children: [
        Container(
          width: w * 0.04,
          height: h * 0.02,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: w * 0.015),
        Text(label, style: AppTextStyles.body2.copyWith(color: AppColors.grey)),
      ],
    );
  }
}
