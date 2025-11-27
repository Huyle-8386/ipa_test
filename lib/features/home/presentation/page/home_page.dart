import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/budget/presentation/pages/budget_route.dart';
import 'package:fintrack/features/budget/presentation/pages/budget_alerts_page.dart';
import 'package:fintrack/features/budget/presentation/pages/budget_suggestions_page.dart';
import 'package:fintrack/features/home/presentation/bloc/home_bloc.dart';
import 'package:fintrack/features/home/presentation/bloc/home_event.dart';
import 'package:fintrack/features/home/presentation/bloc/home_state.dart';
import 'package:fintrack/features/home/presentation/widgets/account_item.dart';
import 'package:fintrack/features/home/presentation/widgets/my_pie_chart.dart';
import 'package:fintrack/features/home/presentation/widgets/transaction_history.dart';
import 'package:fintrack/features/notifications/presentation/page/notifications_page.dart';
import 'package:fintrack/features/notifications/presentation/page/monthly_report_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/features/money_source/presentation/pages/money_source_route.dart';
import 'package:fintrack/features/transaction_history/presentation/pages/transaction_%20history_page.dart';

import '../../../../core/utils/currency_formatter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeStarted());
  }

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox(
        height: h,
        width: w,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.05,
            vertical: h * 0.05,
          ),
          child: ListView(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/images/avartar.png',
                            ),
                            radius: 20,
                          ),
                          SizedBox(width: w * 0.02),
                          BlocBuilder<HomeBloc, HomeState>(
                            builder: (context, state) {
                              String displayName = 'User';
                              if (state is HomeLoaded) {
                                displayName = state.userName;
                              } else if (state is HomeLoading) {
                                displayName = '...';
                              }
                              return Text(
                                displayName,
                                style: AppTextStyles.body1.copyWith(
                                  color: AppColors.grey,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => const NotificationsPage(),
                      //       ),
                      //     );
                      //   },
                      //   child: Row(
                      //     children: [
                      //       Image.asset('assets/icons/notification.png'),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: h * 0.02),
                  Row(
                    children: [
                      Text(
                        'Balance',
                        style: AppTextStyles.heading1.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.01),
                  Row(
                    children: [
                      BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          if (state is HomeLoaded) {
                            return Text(
                              // '\$${state.totalBalance.toStringAsFixed(2)}',
                              CurrencyFormatter.formatVNDWithCurrency(
                                state.totalBalance,
                              ),
                              style: AppTextStyles.heading1.copyWith(
                                color: AppColors.main,
                              ),
                            );
                          }
                          if (state is HomeLoading) {
                            return SizedBox(
                              height: h * 0.04,
                              width: h * 0.04,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.main,
                              ),
                            );
                          }
                          return Text(
                            '\$0.00',
                            style: AppTextStyles.heading1.copyWith(
                              color: AppColors.main,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.01),
                  Container(
                    height: h * 0.2,
                    width: w * 0.9,
                    decoration: BoxDecoration(
                      color: AppColors.widget,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.05,
                        vertical: h * 0.03,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Well done!',
                                  style: AppTextStyles.heading2.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                                SizedBox(height: h * 0.01),
                                Text(
                                  'Your spending reduced by 2% from last month ',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.grey,
                                  ),
                                ),
                                SizedBox(height: h * 0.01),
                                Text(
                                  'View Details',
                                  style: AppTextStyles.body2.copyWith(
                                    color: AppColors.main,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Column(children: [MyPieChart()]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: h * 0.17,
                          child: BlocBuilder<HomeBloc, HomeState>(
                            builder: (context, state) {
                              if (state is HomeLoaded) {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.moneySources.length,
                                  itemBuilder: (context, index) {
                                    final source = state.moneySources[index];
                                    return AccountItem(moneySource: source);
                                  },
                                );
                              } else if (state is HomeLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.main,
                                  ),
                                );
                              } else if (state is HomeError) {
                                return Center(
                                  child: Text(
                                    state.message,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.brightOrange,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.02),
                  Container(
                    height: h * 0.09,
                    width: w * 0.9,
                    decoration: BoxDecoration(
                      color: AppColors.widget,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MonthlyReportPage(userId: uid),
                              ),
                            );
                          },
                          child: Image.asset('assets/icons/swap.png'),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BudgetRoute(uid: uid),
                              ),
                            );
                          },
                          child: Image.asset('assets/icons/analyst.png'),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MoneySourceRoute(uid: uid),
                              ),
                            );
                          },
                          child: Image.asset('assets/icons/deposit.png'),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BudgetAlertsPage(userId: uid),
                              ),
                            );
                          },
                          child: Image.asset('assets/icons/buy.png'),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BudgetSuggestionsPage(userId: uid),
                              ),
                            );
                          },
                          child: Image.asset('assets/icons/add.png'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                  Container(
                    width: w * 0.9,
                    decoration: BoxDecoration(
                      color: AppColors.widget,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: h * 0.02,
                        vertical: h * 0.02,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Transaction History',
                                style: AppTextStyles.body1.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TransactionHistoryPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'See All',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'All',
                                    style: AppTextStyles.body2.copyWith(
                                      color: AppColors.main,
                                    ),
                                  ),
                                  Container(
                                    height: h * 0.003,
                                    width: w * 0.07,
                                    color: AppColors.main,
                                  ),
                                ],
                              ),
                              Text(
                                'Spending',
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                              Text(
                                'Income',
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.02),
                          Row(
                            children: [
                              Text(
                                '2 July 2025',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                              SizedBox(width: w * 0.03),
                              Container(
                                height: h * 0.002,
                                width: w * 0.6,
                                color: AppColors.grey,
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset('assets/icons/taxi.png'),
                                  SizedBox(width: w * 0.03),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Taxi',
                                        style: AppTextStyles.body2.copyWith(
                                          color: AppColors.white,
                                        ),
                                      ),
                                      Text(
                                        'Uber',
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: w * 0.03),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '-\$15',
                                        style: AppTextStyles.body2.copyWith(
                                          color: AppColors.brightOrange,
                                        ),
                                      ),
                                      Text(
                                        '8:25 pm',
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.02),
                          const Divider(),
                          SizedBox(height: h * 0.02),
                          const TransactionHistory(),
                          SizedBox(height: h * 0.02),
                          const Divider(),
                          SizedBox(height: h * 0.02),
                          const TransactionHistory(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
