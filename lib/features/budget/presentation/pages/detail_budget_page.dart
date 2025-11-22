// // lib/features/budget/presentation/pages/detail_budget_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fintrack/core/theme/app_colors.dart';
// import 'package:fintrack/core/theme/app_text_styles.dart';
// import 'package:fintrack/core/utils/size_utils.dart';
// import '../bloc/budget_bloc.dart';
// import '../bloc/budget_state.dart';
// import 'widgets/bar_chart_card.dart';
// import 'widgets/line_chart_card.dart';
// import 'widgets/pie_chart_card.dart';

// class DetailBudgetPage extends StatelessWidget {
//   const DetailBudgetPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final h = SizeUtils.height(context);
//     final w = SizeUtils.width(context);

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.background,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Budget",
//           style: AppTextStyles.body1.copyWith(color: AppColors.white),
//         ),
//       ),
//       body: BlocBuilder<BudgetBloc, BudgetState>(
//         builder: (context, state) {
//           final budget = state.selectedBudget;
//           if (budget == null) {
//             return Center(
//               child: Text(
//                 "No budget selected",
//                 style: AppTextStyles.body2.copyWith(color: AppColors.grey),
//               ),
//             );
//           }

//           final percent = budget.percent.clamp(0, 9999);
//           final percentStr = percent.toStringAsFixed(0);

//           return Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: w * 0.05,
//               vertical: h * 0.02,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header progress summary
//                 Text(
//                   "Spend: \$${budget.spent.toStringAsFixed(0)} / \$${budget.total.toStringAsFixed(0)}",
//                   style: AppTextStyles.caption.copyWith(color: AppColors.grey),
//                 ),
//                 SizedBox(height: h * 0.0005),
//                 // Progress bar + percent right
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(16),
//                         child: LinearProgressIndicator(
//                           value: (budget.total == 0)
//                               ? 0
//                               : (budget.spent / budget.total).clamp(0.0, 1.0),
//                           color: _getColorForStatus(budget.status),
//                           backgroundColor: AppColors.widget,
//                           minHeight: h * 0.012,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: w * 0.03),
//                     Text(
//                       "$percentStr%",
//                       style: AppTextStyles.body2.copyWith(
//                         color: AppColors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: h * 0.02),
//                 // ListView cho các card biểu đồ
//                 Expanded(
//                   child: ListView(
//                     padding: EdgeInsets.zero,
//                     children: [
//                       // Card: Line Chart (Monthly)
//                       Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.all(w * 0.04),
//                         decoration: BoxDecoration(
//                           color: AppColors.widget,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Monthly",
//                               style: AppTextStyles.body2.copyWith(
//                                 color: AppColors.white,
//                               ),
//                             ),
//                             SizedBox(height: h * 0.025),
//                             SizedBox(
//                               height: h * 0.22,
//                               child: LineChartCard(
//                                 spending: budget.monthlySpending,
//                                 budgetLimit: budget.monthlyBudgetLimit,
//                                 h: h,
//                                 w: w,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: h * 0.02),
//                       // Card: Last 6 periods (Bar)
//                       Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.all(w * 0.04),
//                         decoration: BoxDecoration(
//                           color: AppColors.widget,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Last 6 periods",
//                               style: AppTextStyles.body2.copyWith(
//                                 color: AppColors.white,
//                               ),
//                             ),
//                             SizedBox(height: h * 0.025),
//                             SizedBox(
//                               height: h * 0.2,
//                               child: BarChartCard(
//                                 spending: budget.monthlySpending,
//                                 budgets: budget.monthlyBudgetLimit,
//                                 h: h,
//                                 w: w,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: h * 0.02),
//                       // Card: Expenses (Pie)
//                       Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.all(w * 0.04),
//                         decoration: BoxDecoration(
//                           color: AppColors.widget,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Expenses",
//                               style: AppTextStyles.body2.copyWith(
//                                 color: AppColors.white,
//                               ),
//                             ),
//                             SizedBox(height: h * 0.01),
//                             SizedBox(
//                               height: h * 0.24,
//                               child: Row(
//                                 children: [
//                                   SizedBox(width: w * 0.03),
//                                   Expanded(
//                                     child: PieChartCard(
//                                       expenses: budget.expenses,
//                                       h: h,
//                                       w: w,
//                                     ),
//                                   ),
//                                   SizedBox(width: w * 0.1),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: budget.expenses.map((e) {
//                                         return Padding(
//                                           padding: EdgeInsets.only(
//                                             bottom: h * 0.01,
//                                           ),
//                                           child: Row(
//                                             children: [
//                                               Container(
//                                                 width: w * 0.04,
//                                                 height: h * 0.02,
//                                                 decoration: BoxDecoration(
//                                                   color: Color(e.colorValue),
//                                                   borderRadius:
//                                                       BorderRadius.circular(4),
//                                                 ),
//                                               ),
//                                               SizedBox(width: w * 0.03),
//                                               Text(
//                                                 "${e.category}",
//                                                 style: AppTextStyles.body2
//                                                     .copyWith(
//                                                       color: AppColors.white,
//                                                     ),
//                                               ),
//                                               Spacer(),
//                                             ],
//                                           ),
//                                         );
//                                       }).toList(),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: h * 0.05),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Color _getColorForStatus(String status) {
//     switch (status) {
//       case "Within":
//         return AppColors.main;
//       case "Risk":
//         return AppColors.brightOrange;
//       case "Overspending":
//         return AppColors.blue;
//       default:
//         return AppColors.grey;
//     }
//   }
// }
