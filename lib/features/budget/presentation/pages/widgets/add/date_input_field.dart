import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import '../../../bloc/budget_bloc.dart';
import '../../../bloc/budget_event.dart';

class DateInputField extends StatelessWidget {
  final String label;
  final String value;

  const DateInputField({super.key, required this.label, required this.value});

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final bloc = context.read<BudgetBloc>();
    final state = bloc.state;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? state.addStartDate : state.addEndDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (ctx, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.main,
              onPrimary: Colors.black,
              surface: AppColors.widget,
              onSurface: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isStart) {
        bloc.add(AddStartDateChanged(picked));
      } else {
        bloc.add(AddEndDateChanged(picked));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body2.copyWith(color: AppColors.grey)),
        const SizedBox(height: 6),

        GestureDetector(
          onTap: () => _pickDate(context, label == "Start Date"),
          child: Container(
            height: h * 0.07,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: const TextStyle(color: AppColors.white)),
                const Icon(Icons.calendar_today, color: AppColors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
