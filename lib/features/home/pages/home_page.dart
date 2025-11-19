import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/budget/budget_injection.dart';
import 'package:fintrack/features/budget/data/datasources/budget_datasource.dart';
import 'package:fintrack/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:fintrack/features/budget/domain/usecases/get_budgets.dart';
import 'package:fintrack/features/budget/domain/usecases/select_budget.dart';
import 'package:fintrack/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:fintrack/features/budget/presentation/bloc/budget_event.dart';
import 'package:fintrack/features/budget/presentation/pages/budget_page.dart';
import 'package:fintrack/features/home/bloc/home_bloc.dart';
import 'package:fintrack/features/home/pages/account_item.dart';
import 'package:fintrack/features/home/pages/my_pie_chart.dart';
import 'package:fintrack/features/home/pages/transaction_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadAcountsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
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
                          CircleAvatar(
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
                      Row(
                        children: [
                          Image.asset("assets/icons/notification.png"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.02),
                  Row(
                    children: [
                      Text(
                        "Balance",
                        style: AppTextStyles.heading1.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.01),
                  Row(
                    children: [
                      Text(
                        "\$2408.45",
                        style: AppTextStyles.heading1.copyWith(
                          color: AppColors.main,
                        ),
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
                                  "Well done!",
                                  style: AppTextStyles.heading2.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                                SizedBox(height: h * 0.01),
                                Text(
                                  "Your spending reduced by 2% from last month ",
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.grey,
                                  ),
                                ),
                                SizedBox(height: h * 0.01),
                                Text(
                                  "View Details",
                                  style: AppTextStyles.body2.copyWith(
                                    color: AppColors.main,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                MyPieChart(),
                                // Text(
                                //   "View Details",
                                //   style: AppTextStyles.body2.copyWith(
                                //     color: AppColors.main,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.02),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: h * 0.17,
                          child: BlocBuilder<HomeBloc, HomeState>(
                            builder: (context, state) {
                              if (state is HomeLoadedAccount) {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.listAccount.length,
                                  itemBuilder: (context, index) {
                                    final product = state.listAccount[index];
                                    return AccountItem(
                                      images: product.images,
                                      money: product.money,
                                      resource: product.resource,
                                    );
                                  },
                                );
                              } else {
                                return SizedBox();
                              }
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
                        Image.asset("assets/icons/swap.png"),
                        // Image.asset("assets/icons/analyst.png"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) =>
                                      sl<BudgetBloc>()..add(LoadBudgets()),
                                  child: const BudgetPage(),
                                ),
                              ),
                            );
                          },
                          child: Image.asset("assets/icons/analyst.png"),
                        ),

                        Image.asset("assets/icons/deposit.png"),
                        Image.asset("assets/icons/buy.png"),
                        Image.asset("assets/icons/add.png"),
                      ],
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                  Container(
                    // height: h*0.1,
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
                                "Transaction History",
                                style: AppTextStyles.body1.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                "See All",
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.grey,
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
                                    "All",
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
                                "Spending",
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                              Text(
                                "Income",
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
                                "2 July 2025",
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
                                  Image.asset("assets/icons/taxi.png"),
                                  SizedBox(width: w * 0.03),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Taxi",
                                        style: AppTextStyles.body2.copyWith(
                                          color: AppColors.white,
                                        ),
                                      ),
                                      Text(
                                        "Uber",
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
                                        "-\$15",
                                        style: AppTextStyles.body2.copyWith(
                                          color: AppColors.brightOrange,
                                        ),
                                      ),
                                      Text(
                                        "8:25 pm",
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
                          Divider(),
                          SizedBox(height: h * 0.02),
                          TransactionHistory(),
                          SizedBox(height: h * 0.02),
                          Divider(),
                          SizedBox(height: h * 0.02),
                          TransactionHistory(),
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
