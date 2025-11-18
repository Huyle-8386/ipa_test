import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';

class AccountItem extends StatelessWidget {
  final String images;
  final String resource;
  final String money;

  const AccountItem({
    super.key,
    required this.images,
    required this.resource,
    required this.money,
  });

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    return Column(
      children: [
        Container(
          height: h * 0.085,
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: h * 0.01,
          ),
          decoration: BoxDecoration(
            color: AppColors.widget,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset(
                    images,
                    width: w * 0.1,
                    height: w * 0.1,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: w * 0.04),
                  Text(
                    resource,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
              Text(
                money,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: h * 0.01),
      ],
    );
  }
}
