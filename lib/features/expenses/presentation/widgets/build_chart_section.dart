// Widget cho biểu đồ và chú giải
import 'dart:math' as math;
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/features/expenses/domain/entities/expense_entity.dart';
import 'package:flutter/material.dart';

Widget buildChartSection(double? totalValue, List<ExpenseEntity> expenses) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(150, 150),
                painter: PieChartPainter(expenses: expenses),
              ),
              // Hiển thị tổng giá trị đã được tính toán
              Text(
                "\$${(totalValue ?? 0.0).toStringAsFixed(2)}\nTotal",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: AppTextStyles.body1.fontWeight,
                  fontSize: AppTextStyles.heading2.fontSize,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        // Chú giải
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: expenses
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _getCategoryColor(e.categoryName),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          e.categoryName,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: AppTextStyles.body1.fontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    ),
  );
}

// Lớp Painter để vẽ biểu đồ tròn
class PieChartPainter extends CustomPainter {
  final List<ExpenseEntity> expenses;

  PieChartPainter({required this.expenses});

  @override
  void paint(Canvas canvas, Size size) {
    double total = expenses.fold(0, (sum, item) => sum + item.amount);
    if (total == 0) return; // Tránh chia cho 0
    double startAngle = -math.pi / 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    for (var expense in expenses) {
      final sweepAngle = (expense.amount / total) * 2 * math.pi;
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = _getCategoryColor(expense.categoryName);
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }

    // Vẽ một vòng tròn ở giữa để tạo hiệu ứng donut chart
    final innerCirclePaint = Paint()
      ..color = AppColors.background
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.6, innerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Vẽ lại khi dữ liệu thay đổi
  }
}

// Helper color mapping for categories
Color _getCategoryColor(String categoryName) {
  final category = categoryName.toLowerCase();
  if (category.contains('food')) return AppColors.orange;
  if (category.contains('taxi')) return AppColors.blue;
  if (category.contains('shopping')) return AppColors.red;
  if (category.contains('health')) return AppColors.turquoise;
  if (category.contains('travel')) return AppColors.purple;
  if (category.contains('groceries')) return AppColors.green;
  return AppColors.grey;
}
