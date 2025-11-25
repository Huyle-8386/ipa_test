import 'package:fintrack/core/di/injector.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/features/expenses/presentation/bloc/expenses_bloc.dart';
import 'package:fintrack/features/expenses/presentation/bloc/expenses_event.dart';
import 'package:fintrack/features/expenses/presentation/bloc/expenses_state.dart';
import 'package:fintrack/features/expenses/presentation/widgets/build_chart_section.dart';
import 'package:fintrack/features/expenses/presentation/widgets/build_expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/utils/size_utils.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ExpensesBloc>()..add(LoadExpensesData()),
      child: const _ExpensesPageContent(),
    );
  }
}

class _ExpensesPageContent extends StatefulWidget {
  const _ExpensesPageContent();

  @override
  State<_ExpensesPageContent> createState() => _ExpensesPageContentState();
}

class _ExpensesPageContentState extends State<_ExpensesPageContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ExpensesBloc>().add(LoadExpensesData());
  }

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.01),
        child: BlocConsumer<ExpensesBloc, ExpensesState>(
          listener: (context, state) {
            // Xử lý side effects ở đây
            if (state is ExpensesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lỗi: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state is ExpensesLoaded && state.expenses.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Không tìm thấy khoản chi tiêu nào'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ExpensesInitial || state is ExpensesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExpensesLoaded) {
              return _buildContent(context, state, h, w);
            } else if (state is ExpensesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Đã xảy ra lỗi: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ExpensesBloc>().add(LoadExpensesData());
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ExpensesLoaded state,
    double h,
    double w,
  ) {
    // Lấy danh sách categories từ state thay vì hardcode
    final List<String> categories = state.categories;

    // Nếu state không có activeCategory, mặc định là phần tử đầu tiên
    final String activeCategory = state.activeCategory;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: h * 0.02),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              "Expenses",
              style: TextStyle(
                fontWeight: AppTextStyles.body1.fontWeight,
                color: AppColors.white,
                fontSize: AppTextStyles.heading2.fontSize,
              ),
            ),
          ],
        ),

        /// search bar - Thay đổi ở đây
        Container(
          padding: const EdgeInsets.only(bottom: 20, top: 20),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: AppColors.white),
            cursorColor: AppColors.white,
            // Thêm sự kiện onSubmitted để xử lý khi người dùng nhấn Enter
            onSubmitted: (value) {
              context.read<ExpensesBloc>().add(SearchExpenses(value));
            },
            decoration: InputDecoration(
              // prefixIcon: const Icon(Icons.search, color: Colors.white70),
              // Thêm icon tìm kiếm bên phải có thể nhấn để tìm kiếm
              prefixIcon: IconButton(
                icon: const Icon(Icons.search, color: AppColors.white),
                onPressed: () {
                  // Gửi sự kiện tìm kiếm khi nhấn vào icon
                  context.read<ExpensesBloc>().add(
                    SearchExpenses(_searchController.text),
                  );
                },
              ),
              hintText: "Super AI search",
              hintStyle: const TextStyle(color: AppColors.grey),
              filled: true,
              fillColor: AppColors.widget,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // Category navbar
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(categories.length, (index) {
              final category = categories[index];
              final isSelected = activeCategory == category;

              return GestureDetector(
                onTap: () {
                  context.read<ExpensesBloc>().add(
                    FilterExpensesByCategory(category),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? AppColors.main : AppColors.grey,
                        fontSize: AppTextStyles.heading2.fontSize,
                        fontWeight: AppTextStyles.body1.fontWeight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 1,
                      width: 40,
                      color: isSelected ? AppColors.main : AppColors.background,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 20),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Biểu đồ và chú giải với dữ liệu từ BLoC
                // Comparison line: show increase/decrease compared to previous period
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(
                      //   state.isIncrease
                      //       ? Icons.arrow_upward
                      //       : Icons.arrow_downward,
                      //   color: state.isIncrease
                      //       ? Colors.greenAccent
                      //       : Colors.redAccent,
                      // ),
                      // const SizedBox(width: 8),
                      // Text(
                      //   state.isIncrease
                      //       ? 'Increased by \$${state.diff.abs().toStringAsFixed(2)} vs previous'
                      //       : 'Decreased by \$${state.diff.abs().toStringAsFixed(2)} vs previous',
                      //   style: TextStyle(
                      //     color: state.isIncrease
                      //         ? Colors.greenAccent
                      //         : Colors.redAccent,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                    ],
                  ),
                ),

                Center(
                  child: buildChartSection(state.totalValue, state.expenses),
                ),

                const SizedBox(height: 20),

                // Custom widget để hiển thị danh sách chi tiêu từ BLoC
                state.expenses.isEmpty
                    ? buildEmptyExpenseList()
                    : buildExpenseList(
                        state.expenses,
                        state.totalValue,
                        state.previousSums,
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
