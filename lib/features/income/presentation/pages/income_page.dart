import 'package:fintrack/core/di/injector.dart';
import 'package:fintrack/features/income/presentation/bloc/income_bloc.dart';
import 'package:fintrack/features/income/presentation/bloc/income_event.dart';
import 'package:fintrack/features/income/presentation/bloc/income_state.dart';
import 'package:fintrack/features/income/presentation/widgets/build_chart_section.dart';
import 'package:fintrack/features/income/presentation/widgets/build_income_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/utils/size_utils.dart';

class IncomePage extends StatelessWidget {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<IncomeBloc>()..add(LoadIncomeData()),
      child: const _IncomePageContent(),
    );
  }
}

class _IncomePageContent extends StatefulWidget {
  const _IncomePageContent();

  @override
  State<_IncomePageContent> createState() => _IncomePageContentState();
}

class _IncomePageContentState extends State<_IncomePageContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<IncomeBloc>().add(LoadIncomeData());
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
        child: BlocConsumer<IncomeBloc, IncomeState>(
          listener: (context, state) {
            // Xử lý side effects ở đây
            if (state is IncomeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lỗi: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state is IncomeLoaded && state.incomes.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Không tìm thấy khoản thu nhập nào'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is IncomeInitial || state is IncomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is IncomeLoaded) {
              return _buildContent(context, state, h, w);
            } else if (state is IncomeError) {
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
                        context.read<IncomeBloc>().add(LoadIncomeData());
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
    IncomeLoaded state,
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
            const Text(
              "Income",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),

        /// search bar - Thay đổi ở đây
        Container(
          padding: const EdgeInsets.only(bottom: 20, top: 20),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            // Thêm sự kiện onSubmitted để xử lý khi người dùng nhấn Enter
            onSubmitted: (value) {
              context.read<IncomeBloc>().add(SearchIncome(value));
            },
            decoration: InputDecoration(
              // prefixIcon: const Icon(Icons.search, color: Colors.white70),
              // Thêm icon tìm kiếm bên phải có thể nhấn để tìm kiếm
              prefixIcon: IconButton(
                icon: const Icon(Icons.search, color: AppColors.white),
                onPressed: () {
                  // Gửi sự kiện tìm kiếm khi nhấn vào icon
                  context.read<IncomeBloc>().add(
                    SearchIncome(_searchController.text),
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
                  context.read<IncomeBloc>().add(
                    FilterIncomeByCategory(category),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? AppColors.main : Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 1,
                      width: 40,
                      color: isSelected ? AppColors.main : Colors.transparent,
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
                buildChartSection(state.totalValue, state.incomes),
                const SizedBox(height: 20),
                // Custom widget để hiển thị danh sách chi tiêu từ BLoC
                state.incomes.isEmpty
                    ? buildEmptyIncomeList()
                    : buildIncomeList(state.incomes),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
