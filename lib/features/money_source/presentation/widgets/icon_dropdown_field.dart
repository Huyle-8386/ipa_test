// lib/features/money_source/presentation/pages/widgets/icon_dropdown_field.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/size_utils.dart';

class IconDropdownField extends StatefulWidget {
  final TextEditingController controller;

  const IconDropdownField({super.key, required this.controller});

  @override
  State<IconDropdownField> createState() => _IconDropdownFieldState();
}

class _IconDropdownFieldState extends State<IconDropdownField> {
  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    final options = [
      {'label': 'Cash', 'icon': 'assets/icons/cash_usd.png'},
      {'label': 'Bank', 'icon': 'assets/icons/pashabank_usd.png'},
    ];

    String? currentValue = widget.controller.text.isEmpty
        ? null
        : widget.controller.text;

    return DropdownButtonFormField<String>(
      value: currentValue,
      hint: Text(
        'Select Source Type',
        style: AppTextStyles.body2.copyWith(
          color: AppColors.grey,
          fontSize: 16,
        ),
      ),
      dropdownColor: AppColors.widget,
      style: AppTextStyles.body1.copyWith(color: AppColors.white, fontSize: 18),
      decoration: InputDecoration(
        labelText: 'Money Source Type',
        labelStyle: AppTextStyles.body2.copyWith(
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
      items: options.map((opt) {
        return DropdownMenuItem(
          value: opt['icon'],
          child: Row(
            children: [
              Image.asset(opt['icon']!, width: 28, height: 28),
              const SizedBox(width: 12),
              Text(
                opt['label']!,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          widget.controller.text = value;
          setState(() {});
        }
      },
      validator: (val) => val == null || val.isEmpty ? 'Select icon' : null,
    );
  }
}
