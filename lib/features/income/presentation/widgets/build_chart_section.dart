// Widget cho biểu đồ và chú giải
import 'dart:math' as math;
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/features/income/domain/entities/income_entity.dart';
import 'package:flutter/material.dart';

// Widget chỉ hiển thị biểu đồ và chú giải (không có tổng tiền)
Widget buildChartSection(List<IncomeEntity> incomes) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: CustomPaint(
            size: const Size(150, 150),
            painter: PieChartPainter(incomes: incomes),
          ),
        ),
        const SizedBox(width: 40),
        // Chú giải
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: incomes
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

// Widget riêng để hiển thị tổng tiền
Widget buildTotalSection(double totalValue) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Total: ',
          style: TextStyle(
            color: AppColors.white,
            fontSize: AppTextStyles.heading2.fontSize,
            fontWeight: AppTextStyles.heading2.fontWeight,
          ),
        ),
        Text(
          CurrencyFormatter.formatVNDWithCurrency(totalValue),
          style: TextStyle(
            color: AppColors.brightOrange,
            fontWeight: FontWeight.bold,
            fontSize: AppTextStyles.heading2.fontSize,
          ),
        ),
      ],
    ),
  );
}

// Lớp Painter để vẽ biểu đồ tròn
class PieChartPainter extends CustomPainter {
  final List<IncomeEntity> incomes;

  PieChartPainter({required this.incomes});

  @override
  void paint(Canvas canvas, Size size) {
    // Prepare slices: filter non-positive and group very small slices into "Others".
    final filtered = incomes.where((e) => e.amount > 0).toList();
    double total = filtered.fold(0.0, (sum, item) => sum + item.amount);
    if (total <= 0) return; // nothing to draw

    // Build slices with a minimum proportion threshold. Very small slices are
    // accumulated into an "Others" slice so they remain visible.
    const double minProportion = 0.005; // 0.5%
    final List<_Slice> slices = [];
    double othersSum = 0.0;
    for (var e in filtered) {
      final prop = e.amount / total;
      if (prop < minProportion) {
        othersSum += e.amount;
      } else {
        slices.add(_Slice(name: e.categoryName, amount: e.amount));
      }
    }
    if (othersSum > 0) slices.add(_Slice(name: 'Others', amount: othersSum));

    double startAngle = -math.pi / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    for (var s in slices) {
      final sweepAngle = (s.amount / total) * 2 * math.pi;
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = _getCategoryColor(s.name);
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

Color _getCategoryColor(String categoryName) {
  final category = categoryName.toLowerCase();
  if (category.contains('salary')) return AppColors.purple;
  if (category.contains('reward')) return AppColors.scarlet;
  if (category.contains('shopping')) return AppColors.red;
  if (category.contains('allowance')) return AppColors.orange;
  if (category.contains('collections')) return AppColors.royalBlue;
  if (category.contains('profit')) return AppColors.green;
  if (category.contains('business')) return AppColors.turquoise;
  return AppColors.grey;
}

// Small helper to represent a pie slice for drawing
class _Slice {
  final String name;
  final double amount;
  _Slice({required this.name, required this.amount});
}
