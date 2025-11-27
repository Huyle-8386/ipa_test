import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import '../../../bloc/budget_bloc.dart';
import '../../../bloc/budget_event.dart';

class BudgetNameField extends StatefulWidget {
  const BudgetNameField({super.key});

  @override
  State<BudgetNameField> createState() => _BudgetNameFieldState();
}

class _BudgetNameFieldState extends State<BudgetNameField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    final state = context.read<BudgetBloc>().state;
    controller = TextEditingController(text: state.addName);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.watch<BudgetBloc>().state;

    if (controller.text != state.addName) {
      controller.value = TextEditingValue(
        text: state.addName,
        selection: TextSelection.collapsed(offset: state.addName.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

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
      ),
      onChanged: (value) {
        context.read<BudgetBloc>().add(AddNameChanged(value));
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
