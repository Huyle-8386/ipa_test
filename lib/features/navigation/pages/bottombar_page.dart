import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_bloc.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_event.dart';
import 'package:fintrack/features/add_transaction/presentation/page/add_transaction_page.dart';
import 'package:fintrack/features/ai_chat/presentation/page/ai_chat_page.dart';
import 'package:fintrack/features/auth/presentation/page/sign_up_page.dart';
import 'package:fintrack/features/chart/chart_injection.dart';
// import 'package:fintrack/features/chart/bloc/chart_bloc.dart';
import 'package:fintrack/features/chart/data/datasources/chart_data_source.dart';
import 'package:fintrack/features/chart/data/repositories/chart_repository_impl.dart';
import 'package:fintrack/features/chart/domain/usecases/get_chart_data_usecase.dart';
// import 'package:fintrack/features/chart/pages/chart_page.dart';
import 'package:fintrack/features/chart/presentation/bloc/chart_bloc.dart';
import 'package:fintrack/features/chart/presentation/pages/chart_page.dart';
import 'package:fintrack/features/home/bloc/home_bloc.dart';
import 'package:fintrack/features/home/pages/home_page.dart';
import 'package:fintrack/features/navigation/bloc/bottom_bloc.dart';
import 'package:fintrack/features/navigation/pages/bottom_nav_item.dart';
import 'package:fintrack/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:fintrack/features/setting/presentation/pages/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../chart/presentation/bloc/money_source/money_source_bloc.dart';

class BottombarPage extends StatefulWidget {
  const BottombarPage({super.key});

  @override
  State<BottombarPage> createState() => _BottombarPageState();
}

class _BottombarPageState extends State<BottombarPage> {
  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);
    final List<Widget> _page = [
      BlocProvider(create: (context) => HomeBloc(), child: HomePage()),

      ChartPage(),

      // BlocProvider<ChartBloc>(
      //   create: (_) => sl<ChartBloc>()..add(LoadChartDataEvent()),
      //   child: const ChartPage(),
      // ),
      AIChatPage(),

      // BlocProvider(create: (context) => HomeBloc(), child: HomePage()),
      BlocProvider(
        create: (_) => sl<SettingBloc>()..add(LoadSettingCardsEvent()),
        child: const SettingPage(),
      ),
    ];

    return BlocProvider(
      create: (context) => BottomBloc(),
      child: BlocBuilder<BottomBloc, BottomState>(
        builder: (context, state) {
          int _idx = 0;
          if (state is LoadedBottom) {
            _idx = state.currentIndex;
          }
          return Scaffold(
            extendBody: true,
            body: IndexedStack(index: _idx, children: _page),
            backgroundColor: AppColors.background,

            floatingActionButton: FloatingActionButton(
              shape: CircleBorder(),

              backgroundColor: AppColors.main,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddTransactionPage()),
                );
              },

              child: ImageIcon(
                AssetImage("assets/icons/add_bottombar.png"),
                size: 30,
                color: AppColors.white,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              height: h * 0.08,
              color: AppColors.widget,
              notchMargin: h * 0.015,
              shape: CircularNotchedRectangle(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Row()
                    BottomNavItem(
                      iconName: "assets/icons/home_bottombar.png",
                      isActive: _idx == 0,

                      onTapItem: () {
                        context.read<BottomBloc>().add(LoadPageEvent(index: 0));
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: w * 0.2),
                      child: BottomNavItem(
                        iconName: "assets/icons/chart_bottombar.png",
                        isActive: _idx == 1,

                        onTapItem: () {
                          context.read<BottomBloc>().add(
                            LoadPageEvent(index: 1),
                          );
                        },
                      ),
                    ),
                    BottomNavItem(
                      iconName: "assets/icons/chat_bottombar.png",
                      isActive: _idx == 2,

                      onTapItem: () {
                        context.read<BottomBloc>().add(LoadPageEvent(index: 2));
                      },
                    ),
                    BottomNavItem(
                      iconName: "assets/icons/setting_bottombar.png",
                      isActive: _idx == 3,

                      onTapItem: () {
                        context.read<BottomBloc>().add(LoadPageEvent(index: 3));
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
