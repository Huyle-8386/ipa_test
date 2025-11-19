// Widget cho biểu đồ và chú giải
import 'dart:math' as math;
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/features/income/domain/entities/income_entity.dart';
import 'package:flutter/material.dart';

Widget buildChartSection(double? totalValue, List<IncomeEntity> incomes) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(150, 150),
              painter: PieChartPainter(incomes: incomes),
            ),
            // Hiển thị tổng giá trị đã được tính toán
            Text(
              "\$${(totalValue ?? 0.0).toStringAsFixed(2)}\nTotal",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
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
                          color: e.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        e.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
  );
}

// Lớp Painter để vẽ biểu đồ tròn
class PieChartPainter extends CustomPainter {
  final List<IncomeEntity> incomes;

  PieChartPainter({required this.incomes});

  @override
  void paint(Canvas canvas, Size size) {
    double total = incomes.fold(0, (sum, item) => sum + item.value);
    if (total == 0) return; // Tránh chia cho 0
    double startAngle = -math.pi / 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    for (var income in incomes) {
      final sweepAngle = (income.value / total) * 2 * math.pi;
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = income.color;
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
