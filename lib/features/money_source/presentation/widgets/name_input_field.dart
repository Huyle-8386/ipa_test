import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/size_utils.dart';

class NameInputField extends StatelessWidget {
  final TextEditingController controller;

  const NameInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    return TextFormField(
      controller: controller,
      style: AppTextStyles.body1.copyWith(color: AppColors.white, fontSize: 18),
      decoration: InputDecoration(
        labelText: 'Name',
        hintText: 'Enter money source name',
        labelStyle: AppTextStyles.body2.copyWith(
          color: AppColors.grey,
          fontSize: 16,
        ),
        hintStyle: AppTextStyles.body2.copyWith(
          color: AppColors.grey,
          fontSize: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.grey, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.main, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: w * 0.05,
          vertical: h * 0.025,
        ),
      ),
      validator: (val) => val == null || val.isEmpty ? 'Enter name' : null,
    );
  }
}
