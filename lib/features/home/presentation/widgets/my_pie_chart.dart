import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyPieChart extends StatelessWidget {
  const MyPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);
    return SizedBox(
      height: h * 0.14,
      width: w * 0.14,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            swapAnimationDuration: const Duration(milliseconds: 800),
            PieChartData(
              startDegreeOffset: 45,
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  value: 55,
                  radius: 15,
                  color: AppColors.main,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: 35,
                  radius: 15,
                  color: const Color(0xFF425B39),
                  showTitle: false,
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   '\$75',
              //   style: AppTextStyles.heading2.copyWith(color: AppColors.white),
              // ),
              Text(
                'Saved',
                style: AppTextStyles.body1.copyWith(color: AppColors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
