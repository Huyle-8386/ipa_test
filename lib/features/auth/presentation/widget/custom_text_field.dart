import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? errorText;
  final Function(String)? onChanged;
  final Function()? onPasswordToggle;
  final bool isPasswordVisible;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.errorText,
    this.onChanged,
    this.onPasswordToggle,
    this.isPasswordVisible = false,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = widget.isPasswordVisible;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: AppTextStyles.body2.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        // TextField
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && !_isPasswordVisible,
          keyboardType: widget.keyboardType,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          onChanged: widget.onChanged,
          style: AppTextStyles.body1.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.normal,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.body1.copyWith(
              color: AppColors.grey,
              fontWeight: FontWeight.normal,
            ),
            filled: true,
            fillColor: AppColors.widget,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            // Password toggle icon
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                      widget.onPasswordToggle?.call();
                    },
                  )
                : null,
          ),
        ),
        // Error message
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.errorText!,
              style: AppTextStyles.caption.copyWith(color: AppColors.red),
            ),
          ),
      ],
    );
  }
}
