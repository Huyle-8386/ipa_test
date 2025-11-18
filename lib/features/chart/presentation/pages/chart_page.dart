import 'package:fintrack/features/chart/presentation/widgets/account_item.dart';
import 'package:fintrack/features/chart/presentation/widgets/chart_view.dart';
import 'package:fintrack/features/chart/presentation/widgets/filter_button.dart';
import 'package:fintrack/features/chart/presentation/widgets/summary_card.dart';
import 'package:fintrack/features/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import '../bloc/chart_bloc.dart';

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
                      Text(
                        "Phung Hao",
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                  Image.asset("assets/icons/notification.png"),
                ],
              ),
              SizedBox(height: h * 0.02),

              // Search box
              Container(
                height: h * 0.06,
                width: w * 0.9,
                decoration: BoxDecoration(
                  color: AppColors.widget,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  style: AppTextStyles.body1.copyWith(color: AppColors.white),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: h * 0.02),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.white,
                      size: h * 0.03,
                    ),
                    hintText: "Super AI search",
                    hintStyle: AppTextStyles.body1.copyWith(
                      color: AppColors.grey,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: h * 0.02),

              // Chart section
              BlocBuilder<ChartBloc, ChartState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      // Filter buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: ["Daily", "Weekly", "Monthly", "Yearly"]
                            .map(
                              (label) => FilterButton(
                                label: label,
                                selected: state.selectedFilter == label,
                                onTap: () => context.read<ChartBloc>().add(
                                  ChangeFilterEvent(label),
                                ),
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
                            SummaryCard(
                              icon: "assets/icons/icon_huong_len.png",
                              title: 'Income',
                              value: state.chartData.fold(
                                0,
                                (sum, e) => sum + e.income,
                              ),
                              change: SummaryCard.calculateChangePercent(
                                state.chartData.map((e) => e.income).toList(),
                              ),
                              color: AppColors.main,
                            ),
                            SummaryCard(
                              icon: "assets/icons/icon_huong_xuong.png",
                              title: 'Expense',
                              value: state.chartData.fold(
                                0,
                                (sum, e) => sum + e.expense,
                              ),
                              change: SummaryCard.calculateChangePercent(
                                state.chartData.map((e) => e.expense).toList(),
                              ),
                              color: AppColors.brightOrange,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Balance",
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      "\$2408.45",
                      style: AppTextStyles.heading1.copyWith(
                        color: AppColors.main,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.02),

              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoadedAccount) {
                      return ListView.separated(
                        itemCount: state.listAccount.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: h * 0.015),
                        itemBuilder: (context, index) {
                          final acc = state.listAccount[index];
                          return AccountItem(
                            images: acc.images,
                            money: acc.money,
                            resource: acc.resource,
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
