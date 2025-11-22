import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import '../../../bloc/budget_bloc.dart';
import '../../../bloc/budget_event.dart';
import '../../../../domain/entities/money_source_entity.dart';

class MoneySourceDropdown extends StatelessWidget {
  final List<MoneySourceEntity> items;

  const MoneySourceDropdown({
    super.key,
    required this.items, // <<=== PARAMETER BẮT BUỘC
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BudgetBloc>().state;
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    return DropdownButtonFormField<String>(
      // value: state.addSource == null || state.addSource!.isEmpty
      //     ? null
      //     : state.addSource,
      value: state.addSource?.isEmpty ?? true ? null : state.addSource,
      hint: const Text("Source", style: TextStyle(color: Colors.grey)),
      dropdownColor: AppColors.widget,
      iconEnabledColor: AppColors.white,
      style: const TextStyle(color: AppColors.white),

      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.main),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: w * 0.04,
          vertical: h * 0.02,
        ),
      ),

      items: items.map((item) {
        return DropdownMenuItem(
          value: item.id,
          child: Row(
            children: [
              Image.asset(item.icon, width: 24, height: 24),
              const SizedBox(width: 10),
              Text(item.name, style: const TextStyle(color: AppColors.white)),
            ],
          ),
        );
      }).toList(),

      onChanged: (value) {
        if (value != null) {
          context.read<BudgetBloc>().add(AddSourceChanged(value));
        }
      },
    );
  }
}
