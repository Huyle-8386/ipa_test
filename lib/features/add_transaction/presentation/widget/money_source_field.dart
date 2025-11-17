import 'package:fintrack/features/add_transaction/presentation/widget/labeled_text_field.dart';
import 'package:fintrack/features/add_transaction/presentation/widget/money_source_bottom_sheet.dart';
import 'package:flutter/material.dart';

class MoneySourceField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final ValueChanged<String>? onSelected;
  const MoneySourceField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.onSelected,
  });  
  Future<void> _openSheet(BuildContext context) async {
    final result = await MoneySourceBottomSheet.show(context,);
    if (result != null && result.isNotEmpty) {
      controller.text = result;
      onSelected?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LabeledTextField(
      controller: controller,
      label: label,
      hint: hint,
      readOnly: true,
      suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      onTap: () => _openSheet(context),
    );
  }
}