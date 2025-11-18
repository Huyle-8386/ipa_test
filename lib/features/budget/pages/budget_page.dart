import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/budget/pages/widgets/budget_card.dart';
import 'package:fintrack/features/budget/pages/widgets/filter_tab.dart';
import 'package:flutter/material.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: const Icon(Icons.arrow_back_ios, color: AppColors.white),
        title: Text(
          "Budget",
          style: AppTextStyles.body1.copyWith(color: AppColors.white),
        ),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.05,
            vertical: h * 0.02,
          ),
          child: Column(
            children: [
              FilterTab(),
              SizedBox(height: h * 0.03),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BudgetCard(),
                      SizedBox(height: h * 0.025),

                      //  Khung thêm budget
                      CustomPaint(
                        painter: DashedRectPainter(color: AppColors.grey),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: h * 0.04,
                            horizontal: w * 0.04,
                          ),
                          child: Column(
                            children: [
                              Image.asset("assets/icons/button_add.png"),
                              SizedBox(height: h * 0.01),
                              Text(
                                "Add new budget",
                                style: AppTextStyles.body1.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: h * 0.05),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// vẽ viền nét đứt
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.2,
    this.dashWidth = 6,
    this.dashSpace = 4,
    this.borderRadius = 16,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    // vẽ nét đứt
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        final extractPath = metric.extractPath(
          distance,
          next.clamp(0, metric.length),
        );
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
