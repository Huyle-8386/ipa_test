// lib/features/budget/presentation/pages/budget_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:fintrack/features/budget/presentation/bloc/category/category_bloc.dart';
import 'package:fintrack/features/budget/presentation/bloc/category/category_event.dart';
import 'package:fintrack/features/budget/presentation/pages/add_budget_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../../data/datasources/budget_remote_data_source.dart';
import '../../domain/usecases/add_budget.dart';
import '../../domain/usecases/delete_budget.dart';
import '../../domain/usecases/update_budget.dart';
import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';
import '../bloc/money_sources/money_source_bloc.dart';
import '../bloc/money_sources/money_source_event.dart';
import 'widgets/filter_tab.dart';
import 'widgets/budget_card.dart';
import '../../domain/usecases/get_budgets.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';

// class BudgetPage extends StatelessWidget {
//   const BudgetPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final h = SizeUtils.height(context);
//     final w = SizeUtils.width(context);

//     // Provide the bloc here if not provided higher
//     return BlocProvider(
//       create: (_) {
//         final uid = FirebaseAuth.instance.currentUser!.uid;

//         final repo = BudgetRepositoryImpl(
//           BudgetRemoteDataSource(FirebaseFirestore.instance),
//         );

//         final bloc = BudgetBloc(
//           addBudgetUsecase: AddBudget(repo),
//           getBudgetsUsecase: GetBudgets(repo),
//           updateBudgetUsecase: UpdateBudget(repo),
//           deleteBudgetUsecase: DeleteBudget(repo),
//         );

//         // phải truyền uid cho LoadBudgets
//         bloc.add(LoadBudgets(uid));

//         return bloc;

//         // final repo = BudgetRepositoryImpl();
//         // final usecase = GetBudgets(repo);
//         // final bloc = BudgetBloc(getBudgets: usecase);
//         // // Load initial budgets
//         // bloc.add(const LoadBudgets());
//         // return bloc;
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.background,
//         appBar: AppBar(
//           backgroundColor: AppColors.background,
//           leading: const Icon(Icons.arrow_back_ios, color: AppColors.white),
//           title: Text(
//             "Budget",
//             style: AppTextStyles.body1.copyWith(color: AppColors.white),
//           ),
//         ),
//         body: Container(
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: w * 0.05,
//               vertical: h * 0.02,
//             ),
//             child: Column(
//               children: [
//                 const FilterTab(),
//                 SizedBox(height: h * 0.03),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         // const BudgetCard(),
//                         SizedBox(height: h * 0.025),
//                         //  Khung thêm budget (kept UI)
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) {
//                                   final uid =
//                                       FirebaseAuth.instance.currentUser!.uid;

//                                   return MultiBlocProvider(
//                                     providers: [
//                                       // Reuse BudgetBloc
//                                       BlocProvider.value(
//                                         value: context.read<BudgetBloc>(),
//                                       ),

//                                       BlocProvider(
//                                         create: (_) => sl<CategoryBloc>()
//                                           ..add(const LoadCategories(false)),
//                                       ),

//                                       BlocProvider(
//                                         create: (_) =>
//                                             sl<MoneySourceBloc>()
//                                               ..add(LoadMoneySources(uid)),
//                                       ),
//                                     ],
//                                     child: AddBudgetPage(),
//                                   );
//                                 },
//                               ),
//                             );
//                           },
//                           child: CustomPaint(
//                             painter: DashedRectPainter(color: AppColors.grey),
//                             child: Container(
//                               width: double.infinity,
//                               padding: EdgeInsets.symmetric(
//                                 vertical: h * 0.04,
//                                 horizontal: w * 0.04,
//                               ),
//                               child: Column(
//                                 children: [
//                                   Image.asset("assets/icons/button_add.png"),
//                                   SizedBox(height: h * 0.01),
//                                   Text(
//                                     "Add new budget",
//                                     style: AppTextStyles.body1.copyWith(
//                                       color: AppColors.grey,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: h * 0.05),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // vẽ viền nét đứt
// class DashedRectPainter extends CustomPainter {
//   final Color color;
//   final double strokeWidth;
//   final double dashWidth;
//   final double dashSpace;
//   final double borderRadius;

//   DashedRectPainter({
//     required this.color,
//     this.strokeWidth = 1.2,
//     this.dashWidth = 6,
//     this.dashSpace = 4,
//     this.borderRadius = 16,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke;

//     final path = Path()
//       ..addRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromLTWH(0, 0, size.width, size.height),
//           Radius.circular(borderRadius),
//         ),
//       );

//     // vẽ nét đứt
//     final pathMetrics = path.computeMetrics();
//     for (final metric in pathMetrics) {
//       double distance = 0.0;
//       while (distance < metric.length) {
//         final next = distance + dashWidth;
//         final extractPath = metric.extractPath(
//           distance,
//           next.clamp(0, metric.length),
//         );
//         canvas.drawPath(extractPath, paint);
//         distance += dashWidth + dashSpace;
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    // Provide the bloc here if not provided higher
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
              const FilterTab(),
              SizedBox(height: h * 0.03),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const BudgetCard(),
                      SizedBox(height: h * 0.025),
                      //  Khung thêm budget (kept UI)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                final uid =
                                    FirebaseAuth.instance.currentUser!.uid;

                                return MultiBlocProvider(
                                  providers: [
                                    // Reuse BudgetBloc
                                    BlocProvider.value(
                                      value: context.read<BudgetBloc>(),
                                    ),

                                    BlocProvider(
                                      create: (_) =>
                                          sl<CategoryBloc>()
                                            ..add(const LoadCategories(false)),
                                    ),

                                    BlocProvider(
                                      create: (_) =>
                                          sl<MoneySourceBloc>()
                                            ..add(LoadMoneySources(uid)),
                                    ),
                                  ],
                                  child: AddBudgetPage(),
                                );
                              },
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
