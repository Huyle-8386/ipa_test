import 'package:fintrack/features/income/data/datasources/income_data.dart';
import 'package:fintrack/features/income/presentation/bloc/income_event.dart';
import 'package:fintrack/features/income/presentation/bloc/income_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  IncomeBloc() : super(IncomeInitial()) {
    on<LoadIncomeData>(_onLoadIncomeData);
    on<FilterIncomeByCategory>(_onFilterIncomeByCategory);
    on<SearchIncome>(_onSearchIncome);
  }

  void _onLoadIncomeData(
    LoadIncomeData event,
    Emitter<IncomeState> emit,
  ) async {
    emit(IncomeLoading());

    try {
      // Trong trường hợp thực tế, bạn có thể gọi API hoặc repository ở đây
      // Giả lập việc tải dữ liệu
      // await Future.delayed(const Duration(milliseconds: 500));
      await Future.delayed(const Duration(milliseconds: 100));

      final allIncomes = incomes; // Lấy từ incomes_data.dart
      final total = totalValue; // Lấy từ incomes_data.dart
      final allCategories = categories; // Lấy từ incomes_data.dart

      emit(
        IncomeLoaded(
          incomes: allIncomes,
          totalValue: total,
          activeCategory: allCategories[0], // Default là Daily
          categories: allCategories,
        ),
      );
    } catch (e) {
      emit(IncomeError(e.toString()));
    }
  }

  void _onFilterIncomeByCategory(
    FilterIncomeByCategory event,
    Emitter<IncomeState> emit,
  ) async {
    if (state is IncomeLoaded) {
      final currentState = state as IncomeLoaded;

      emit(IncomeLoading());

      try {
        // Trong thực tế, bạn sẽ lọc dữ liệu theo category từ repository hoặc API
        // Giả lập việc lọc dữ liệu
        await Future.delayed(const Duration(milliseconds: 100));

        // Giả sử các loại chi tiêu khác nhau theo category
        List<IncomeData> filteredIncomes;

        switch (event.category) {
          case 'Daily':
            filteredIncomes = incomes.take(3).toList();
            break;
          case 'Weekly':
            filteredIncomes = incomes.take(4).toList();
            break;
          case 'Monthly':
            filteredIncomes = incomes.take(5).toList();
            break;
          case 'Yearly':
            filteredIncomes = incomes;
            break;
          default:
            filteredIncomes = incomes;
        }

        final total = filteredIncomes.fold(
          0.0,
          (sum, item) => sum + item.value,
        );

        emit(
          IncomeLoaded(
            incomes: filteredIncomes,
            totalValue: total,
            activeCategory: event.category,
            categories:
                currentState.categories, // Giữ nguyên danh sách categories
          ),
        );
      } catch (e) {
        emit(IncomeError(e.toString()));
      }
    }
  }

  void _onSearchIncome(SearchIncome event, Emitter<IncomeState> emit) async {
    if (state is IncomeLoaded) {
      final currentState = state as IncomeLoaded;
      if (event.query.isEmpty) {
        // Nếu query rỗng, trả về toàn bộ expenses theo category hiện tại
        add(FilterIncomeByCategory(currentState.activeCategory));
        return;
      }

      emit(IncomeLoading());

      try {
        // Giả lập tìm kiếm
        await Future.delayed(const Duration(milliseconds: 300));

        final searchResults = incomes
            .where(
              (income) =>
                  income.name.toLowerCase().contains(event.query.toLowerCase()),
            )
            .toList();

        final total = searchResults.fold(0.0, (sum, item) => sum + item.value);

        emit(
          IncomeLoaded(
            incomes: searchResults,
            totalValue: total,
            activeCategory: currentState.activeCategory,
            categories:
                currentState.categories, // Giữ nguyên danh sách categories
          ),
        );
      } catch (e) {
        emit(IncomeError(e.toString()));
      }
    }
  }
}
