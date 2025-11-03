import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';

class BarChartCard extends StatelessWidget {
  final List<double> spending;
  final List<double> budgets;
  final double h;
  final double w;

  const BarChartCard({
    super.key,
    required this.spending,
    required this.budgets,
    required this.h,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    if (spending.isEmpty || budgets.isEmpty) {
      return Center(
        child: Text("No data", style: TextStyle(color: AppColors.grey)),
      );
    }

    // 🔹 Lấy 6 tháng gần nhất
    final now = DateTime.now();
    final months = List.generate(6, (i) {
      final d = DateTime(now.year, now.month - 5 + i);
      return DateFormat('MMM').format(d);
    });

    // 🔹 Giới hạn dữ liệu 6 tháng gần nhất
    final startIdx = spending.length > 6 ? spending.length - 6 : 0;
    final lastSpending = spending.sublist(startIdx);
    final lastBudgets = budgets.sublist(startIdx);

    final maxY = lastSpending.reduce((a, b) => a > b ? a : b) * 1.2;
    final interval = (maxY / 3).ceilToDouble();

    Color getColor(double spend, double budget) {
      final ratio = (budget == 0) ? 0 : spend / budget;
      if (ratio < 0.8) return AppColors.main;
      if (ratio < 1.0) return AppColors.brightOrange;
      return AppColors.blue;
    }

    return SizedBox(
      height: h * 0.3,
      width: w,
      child: Column(
        children: [
          Expanded(
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: interval,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${value.toInt()}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.grey,
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
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              months[idx],
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.grey,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barGroups: List.generate(lastSpending.length, (i) {
                  final spend = lastSpending[i];
                  final budget = i < lastBudgets.length ? lastBudgets[i] : 0;
                  final color = getColor(spend, budget.toDouble());
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: spend,
                        width: 18,
                        borderRadius: BorderRadius.circular(6),
                        color: color,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          SizedBox(height: h * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(h, w, AppColors.main, "Within"),
              SizedBox(width: w * 0.05),
              _buildLegendItem(h, w, AppColors.brightOrange, "Risk"),
              SizedBox(width: w * 0.05),
              _buildLegendItem(h, w, AppColors.blue, "Overspending"),
            ],
          ),
        ],
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
