import 'package:fintrack/features/chart/presentation/widgets/account_item.dart';
import 'package:fintrack/features/chart/presentation/widgets/chart_view.dart';
import 'package:fintrack/features/chart/presentation/widgets/filter_button.dart';
import 'package:fintrack/features/chart/presentation/widgets/summary_card.dart';
import 'package:fintrack/features/expenses/presentation/pages/expenses_page.dart';
import 'package:fintrack/features/income/presentation/pages/income_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../bloc/chart_bloc.dart';
import '../bloc/money_source/money_source_bloc.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    /// ALWAYS LOAD DATA WHEN CHART TAB IS OPENED
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ChartBloc>().add(LoadChartDataEvent());
      context.read<MoneySourceBloc>().add(LoadMoneySourcesEvent());
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.05,
            vertical: h * 0.02,
          ),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage(
                          "assets/images/avartar.png",
                        ),
                        radius: 20,
                      ),
                      SizedBox(width: w * 0.02),
                      BlocBuilder<ChartBloc, ChartState>(
                        builder: (context, state) {
                          final name =
                              state.chartData.isEmpty &&
                                  state.userName == 'User'
                              ? '...'
                              : state.userName;
                          return Text(
                            name,
                            style: AppTextStyles.body1.copyWith(
                              color: AppColors.grey,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  // Image.asset("assets/icons/notification.png"),
                ],
              ),

              SizedBox(height: h * 0.02),

              // Search box
              // Container(
              //   height: h * 0.06,
              //   width: w * 0.9,
              //   decoration: BoxDecoration(
              //     color: AppColors.widget,
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: TextField(
              //     controller: _searchController,
              //     style: AppTextStyles.body1.copyWith(color: AppColors.white),
              //     decoration: InputDecoration(
              //       contentPadding: EdgeInsets.symmetric(vertical: h * 0.02),
              //       prefixIcon: Icon(
              //         Icons.search,
              //         color: AppColors.white,
              //         size: h * 0.03,
              //       ),
              //       hintText: "Super AI search",
              //       hintStyle: AppTextStyles.body1.copyWith(
              //         color: AppColors.grey,
              //       ),
              //       border: InputBorder.none,
              //     ),
              //   ),
              // ),

              // SizedBox(height: h * 0.02),

              // Chart section
              BlocBuilder<ChartBloc, ChartState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      // Filter buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: ["Weekly", "Monthly", "Yearly"]
                            .map(
                              (label) => FilterButton(
                                label: label,
                                selected: state.selectedFilter == label,
                                onTap: () {
                                  context.read<ChartBloc>().add(
                                    ChangeFilterEvent(label),
                                  );
                                },
                              ),
                            )
                            .toList(),
                      ),

                      SizedBox(height: h * 0.02),

                      // Chart view
                      if (state.chartData.isNotEmpty)
                        ChartView(data: state.chartData)
                      else
                        const CircularProgressIndicator(),

                      SizedBox(height: h * 0.02),

                      // Summary cards
                      if (state.chartData.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const IncomePage(),
                                  ),
                                );
                              },
                              child: SummaryCard(
                                icon: "assets/icons/icon_huong_len.png",
                                title: 'Income',
                                value: state.chartData.fold(
                                  0,
                                  (sum, e) => sum + e.income,
                                ),
                                change: state.incomeChangePercent,
                                color: AppColors.main,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ExpensesPage(),
                                  ),
                                );
                              },
                              child: SummaryCard(
                                icon: "assets/icons/icon_huong_xuong.png",
                                title: 'Expense',
                                value: state.chartData.fold(
                                  0,
                                  (sum, e) => sum + e.expense,
                                ),
                                change: state.expenseChangePercent,
                                color: AppColors.brightOrange,
                              ),
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),

              SizedBox(height: h * 0.02),

              /// Balance info
              Align(
                alignment: Alignment.centerLeft,
                child: BlocBuilder<MoneySourceBloc, MoneySourceState>(
                  builder: (context, state) {
                    double totalBalance = 0;

                    if (state is MoneySourceLoaded) {
                      totalBalance = state.list.fold(
                        0,
                        (sum, item) => sum + item.balance,
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Balance",
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.formatVNDWithCurrency(totalBalance),
                          style: AppTextStyles.heading1.copyWith(
                            color: AppColors.main,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(height: h * 0.02),

              Expanded(
                child: BlocBuilder<MoneySourceBloc, MoneySourceState>(
                  builder: (context, state) {
                    if (state is MoneySourceLoaded) {
                      final list = state.list;
                      return ListView.separated(
                        itemCount: list.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: h * 0.015),
                        itemBuilder: (context, index) {
                          final ms = list[index];
                          return AccountItem(
                            images: ms.icon,
                            resource: ms.name,
                            money: CurrencyFormatter.formatVNDWithCurrency(
                              ms.balance,
                            ),
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
