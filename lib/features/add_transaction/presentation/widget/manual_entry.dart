import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ManualEntry extends StatelessWidget {
  final bool active;
  final String icon;
  final String text;
  final VoidCallback? onTap;

  const ManualEntry({
    super.key,
    required this.active,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  icon,
                  color: active ? AppColors.main : AppColors.white,
                ),
                Text(
                  text,
                  style: AppTextStyles.body2.copyWith(
                    color: active ? AppColors.main : AppColors.white,
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 2,
                color: active ? AppColors.main : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
