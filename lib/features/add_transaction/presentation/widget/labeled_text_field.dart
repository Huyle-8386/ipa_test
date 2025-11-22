import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final bool readOnly;
  final bool required; // <--- thêm field này
  final String? errorText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  const LabeledTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.required = false, // <--- mặc định không bắt buộc
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      keyboardType: keyboardType,
      cursorColor: AppColors.grey,
      style: TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        hintText: hint,
        labelText: required ? "$label *" : label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: AppTextStyles.caption.copyWith(color: AppColors.main),
        floatingLabelStyle: AppTextStyles.caption.copyWith(
          color: AppColors.grey,
        ),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.main),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
