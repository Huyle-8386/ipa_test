import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import '../../../bloc/budget_bloc.dart';
import '../../../bloc/budget_event.dart';

class BudgetNameField extends StatelessWidget {
  const BudgetNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    final state = context.watch<BudgetBloc>().state;

    final controller = TextEditingController(text: state.addName);

    return TextFormField(
      controller: controller,
      style: const TextStyle(color: AppColors.white),

      decoration: InputDecoration(
        labelText: "Budget",
        hintText: "Enter Budget Name",
        hintStyle: const TextStyle(color: AppColors.grey),
        labelStyle: const TextStyle(color: AppColors.grey),

        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.main),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

        contentPadding: EdgeInsets.symmetric(
          horizontal: w * 0.04,
          vertical: h * 0.02,
        ),
      ),

      onChanged: (value) {
        context.read<BudgetBloc>().add(AddNameChanged(value));
      },
    );
  }
}
