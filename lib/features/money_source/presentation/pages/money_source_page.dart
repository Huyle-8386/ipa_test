import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/size_utils.dart';
import '../bloc/money_source_bloc.dart';
import '../bloc/money_source_event.dart';
import '../bloc/money_source_state.dart';
import '../widgets/money_source_form_page.dart';
import '../widgets/money_source_item.dart';
import '../../../navigation/pages/bottombar_page.dart';

class MoneySourcePage extends StatelessWidget {
  final String uid;

  const MoneySourcePage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
        //   onPressed: () => Navigator.pop(context),
        // ),
        leading: SizedBox(),
        title: Text(
          'Money Sources',
          style: AppTextStyles.body1.copyWith(color: AppColors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<MoneySourceBloc, MoneySourceState>(
                builder: (context, state) {
                  if (state is MoneySourceLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MoneySourceLoaded) {
                    final list = state.moneySources;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ...list.map(
                            (moneySource) => Padding(
                              padding: EdgeInsets.only(bottom: h * 0.015),
                              child: MoneySourceItem(
                                moneySource: moneySource,
                                onEdit: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MoneySourceFormPage(
                                        uid: uid,
                                        bloc: context.read<MoneySourceBloc>(),
                                        moneySource: moneySource,
                                      ),
                                    ),
                                  );
                                },
                                onDelete: () =>
                                    context.read<MoneySourceBloc>().add(
                                      DeleteMoneySourceEvent(
                                        uid: uid,
                                        id: moneySource.id,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.03),
                          // Add new money source button
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MoneySourceFormPage(
                                    uid: uid,
                                    bloc: context.read<MoneySourceBloc>(),
                                  ),
                                ),
                              );
                            },
                            child: CustomPaint(
                              painter: DashedRectPainter(color: AppColors.grey),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: h * 0.04,
                                  horizontal: w * 0.04,
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 36,
                                      color: AppColors.grey,
                                    ),
                                    SizedBox(height: h * 0.01),
                                    Text(
                                      "Add new money source",
                                      style: AppTextStyles.body1.copyWith(
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.05),
                          if (list.isNotEmpty)
                            SizedBox(
                              width: double.infinity,
                              height: h * 0.065,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.main,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const BottombarPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Go to Home',
                                  style: AppTextStyles.body1.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  } else if (state is MoneySourceError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dashed rectangle painter
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
