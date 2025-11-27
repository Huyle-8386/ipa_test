// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fintrack/core/theme/app_colors.dart';
// import 'package:fintrack/core/theme/app_text_styles.dart';
// import 'package:fintrack/core/utils/size_utils.dart';
// import '../../../bloc/budget_bloc.dart';
// import '../../../bloc/budget_event.dart';

// class AmountInputField extends StatelessWidget {
//   const AmountInputField({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final h = SizeUtils.height(context);
//     final w = SizeUtils.width(context);

//     final state = context.watch<BudgetBloc>().state;

//     final controller = TextEditingController(text: state.addAmount);

//     return TextFormField(
//       controller: controller,
//       keyboardType: TextInputType.number,
//       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//       style: const TextStyle(color: AppColors.white),

//       decoration: InputDecoration(
//         labelText: "Amount",
//         hintText: "\$0",
//         hintStyle: const TextStyle(color: AppColors.grey),
//         labelStyle: const TextStyle(color: AppColors.grey),

//         enabledBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: AppColors.grey),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: AppColors.main),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         contentPadding: EdgeInsets.symmetric(
//           horizontal: w * 0.04,
//           vertical: h * 0.02,
//         ),
//       ),

//       onChanged: (value) {
//         context.read<BudgetBloc>().add(AddAmountChanged(value));
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import '../../../bloc/budget_bloc.dart';
import '../../../bloc/budget_event.dart';

class AmountInputField extends StatefulWidget {
  const AmountInputField({super.key});

  @override
  State<AmountInputField> createState() => _AmountInputFieldState();
}

class _AmountInputFieldState extends State<AmountInputField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    final state = context.read<BudgetBloc>().state;
    controller = TextEditingController(text: state.addAmount);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.watch<BudgetBloc>().state;

    if (controller.text != state.addAmount) {
      controller.value = TextEditingValue(
        text: state.addAmount,
        selection: TextSelection.collapsed(offset: state.addAmount.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        labelText: "Amount",
        hintText: "\$0",
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
        context.read<BudgetBloc>().add(AddAmountChanged(value));
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
