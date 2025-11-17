import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/features/add_transaction/presentation/widget/labeled_text_field.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;

  /// Bật chọn giờ sau khi chọn ngày
  final bool pickTime;
  final ValueChanged<String>? onDatePicked;

  /// Múi giờ 24h hay 12h không ảnh hưởng showTimePicker,
  /// nhưng bạn có thể format lại text theo ý (ở dưới).
  const DatePickerField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.pickTime = false,
    this.onDatePicked,
  });

  Future<void> _pickDateTime(BuildContext context) async {
    // 1) Chọn ngày
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ThemeData.dark().colorScheme.copyWith(
              primary: AppColors.main,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date == null) return;

    if (!pickTime) {
      final value = _formatDate(date);
      controller.text = value;
      onDatePicked?.call(value); // <-- GỌI CALLBACK
      return;
    }

    // 2) Nếu bật pickTime, chọn giờ
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ThemeData.dark().colorScheme.copyWith(
              primary: AppColors.main,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time == null) {
      // Người dùng hủy chọn giờ -> vẫn ghi mỗi ngày
      final value = _formatDate(date);
      controller.text = value;
      onDatePicked?.call(value); // <-- GỌI CALLBACK
      return;
    }

    final dt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    final value = _formatDateTime(dt);
    controller.text = value;
    onDatePicked?.call(value); // yyyy-MM-dd HH:mm
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  String _formatDate(DateTime d) => "${d.year}-${_two(d.month)}-${_two(d.day)}";

  String _formatDateTime(DateTime d) =>
      "${d.year}-${_two(d.month)}-${_two(d.day)} ${_two(d.hour)}:${_two(d.minute)}";

  @override
  Widget build(BuildContext context) {
    return LabeledTextField(
      controller: controller,
      label: label,
      hint: hint ?? (pickTime ? "yyyy-MM-dd HH:mm" : "yyyy-MM-dd"),
      readOnly: true,
      suffixIcon: const Icon(Icons.calendar_today, color: Colors.white),
      onTap: () => _pickDateTime(context),
    );
  }
}
