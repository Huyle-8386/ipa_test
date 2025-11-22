// // lib/features/budget/presentation/pages/widgets/pie_chart_card.dart
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:fintrack/core/theme/app_colors.dart';
// import 'package:fintrack/core/theme/app_text_styles.dart';
// import '../../../domain/entities/budget_entity.dart';

// class PieChartCard extends StatelessWidget {
//   final List<BudgetExpenseEntity> expenses;
//   final double h;
//   final double w;

//   const PieChartCard({
//     super.key,
//     required this.expenses,
//     required this.h,
//     required this.w,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (expenses.isEmpty) {
//       return const Center(
//         child: Text("No data", style: TextStyle(color: AppColors.grey)),
//       );
//     }

//     final total = expenses.fold<double>(0, (p, e) => p + e.amount);

//     final sections = expenses.map((e) {
//       final percentage = total == 0 ? 0 : (e.amount / total) * 100;
//       return PieChartSectionData(
//         value: percentage.toDouble(),
//         color: Color(e.colorValue),
//         radius: h * 0.03,
//         showTitle: false,
//         borderSide: BorderSide.none,
//       );
//     }).toList();

//     return SizedBox(
//       height: h * 0.35,
//       width: w,
//       child: Column(
//         children: [
//           //  Biểu đồ
//           SizedBox(
//             height: h * 0.22,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 PieChart(
//                   PieChartData(
//                     sections: sections,
//                     centerSpaceRadius: h * 0.065,
//                     sectionsSpace: 0,
//                   ),
//                 ),
//                 //  Phần hiển thị total
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       '\$${total.toStringAsFixed(0)}',
//                       style: AppTextStyles.body1.copyWith(
//                         color: AppColors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Total',
//                       style: AppTextStyles.caption.copyWith(
//                         color: AppColors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: h * 0.015),
//         ],
//       ),
//     );
//   }
// }
