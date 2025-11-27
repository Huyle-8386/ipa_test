import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/chart/domain/entities/money_source_entity.dart';
import 'package:flutter/material.dart';

class AccountItem extends StatelessWidget {
  final MoneySourceEntity moneySource;

  const AccountItem({super.key, required this.moneySource});

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.02),
      child: Container(
        height: h * 0.17,
        width: w * 0.35,
        decoration: BoxDecoration(
          color: AppColors.widget,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.03,
            vertical: h * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(moneySource.icon),
              SizedBox(height: h * 0.01),
              Text(
                '\$${moneySource.balance.toStringAsFixed(2)}',
                style: AppTextStyles.body1.copyWith(color: AppColors.white),
              ),
              SizedBox(height: h * 0.01),
              Text(
                moneySource.name,
                style: AppTextStyles.caption.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
