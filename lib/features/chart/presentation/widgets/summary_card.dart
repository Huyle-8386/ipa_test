import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';

class SummaryCard extends StatelessWidget {
  final String icon;
  final String title;
  final double value;
  final double change;
  final Color color;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.change,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    return Container(
      width: w * 0.41,
      padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.015),
      decoration: BoxDecoration(
        color: AppColors.widget,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            width: w * 0.08,
            height: w * 0.08,
            fit: BoxFit.contain,
          ),
          SizedBox(width: w * 0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body1.copyWith(color: AppColors.white),
              ),
              SizedBox(height: h * 0.005),
              Text(
                "${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)}%",
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Tính % thay đổi giữa hai giá trị cuối cùng
  static double calculateChangePercent(List<double> values) {
    if (values.length < 2) return 0.0;
    final last = values.last;
    final previous = values[values.length - 2];
    if (previous == 0) return 0.0;
    return ((last - previous) / previous) * 100;
  }
}
