import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:flutter/material.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset("assets/icons/food.png"),
            SizedBox(width: w * 0.03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Taxi",
                  style: AppTextStyles.body2.copyWith(color: AppColors.white),
                ),
                Text(
                  "Uber",
                  style: AppTextStyles.caption.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: w * 0.03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "+\$350",
                  style: AppTextStyles.body2.copyWith(color: AppColors.main),
                ),
                Text(
                  "9:45 pm",
                  style: AppTextStyles.caption.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
