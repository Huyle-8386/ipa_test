import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double height;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius borderRadius;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.height = 56,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isEnabled
        ? (backgroundColor ?? AppColors.main)
        : AppColors.grey;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor ?? Colors.black,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          disabledBackgroundColor: AppColors.grey,
          disabledForegroundColor: Colors.black54,
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(textColor ?? Colors.black),
                ),
              )
            : Text(
                label,
                style: AppTextStyles.body1.copyWith(
                  color: textColor ?? Colors.black,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
