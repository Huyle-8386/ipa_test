import 'package:fintrack/features/expenses/presentation/bloc/expenses_event.dart';
import 'package:fintrack/features/expenses/presentation/bloc/expenses_state.dart';
import 'package:fintrack/features/expenses/data/datasources/expenses_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  ExpensesBloc() : super(ExpensesInitial()) {
    on<LoadExpensesData>(_onLoadExpensesData);
    on<FilterExpensesByCategory>(_onFilterExpensesByCategory);
    on<SearchExpenses>(_onSearchExpenses);
  }

  void _onLoadExpensesData(
    LoadExpensesData event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(ExpensesLoading());

    try {
      // Trong trường hợp thực tế, bạn có thể gọi API hoặc repository ở đây
      // Giả lập việc tải dữ liệu
      // await Future.delayed(const Duration(milliseconds: 500));
      await Future.delayed(const Duration(milliseconds: 100));

      final allExpenses = expenses; // Lấy từ expenses_data.dart
      final total = totalValue; // Lấy từ expenses_data.dart
      final allCategories = categories; // Lấy từ expenses_data.dart

      emit(
        ExpensesLoaded(
          expenses: allExpenses,
          totalValue: total,
          activeCategory: allCategories[0], // Default là Daily
          categories: allCategories,
        ),
      );
    } catch (e) {
      emit(ExpensesError(e.toString()));
    }
  }

  void _onFilterExpensesByCategory(
    FilterExpensesByCategory event,
    Emitter<ExpensesState> emit,
  ) async {
    if (state is ExpensesLoaded) {
      final currentState = state as ExpensesLoaded;

      emit(ExpensesLoading());

      try {
        // Trong thực tế, bạn sẽ lọc dữ liệu theo category từ repository hoặc API
        // Giả lập việc lọc dữ liệu
        await Future.delayed(const Duration(milliseconds: 100));

        // Giả sử các loại chi tiêu khác nhau theo category
        List<ExpenseData> filteredExpenses;

        switch (event.category) {
          case 'Daily':
            filteredExpenses = expenses.take(3).toList();
            break;
          case 'Weekly':
            filteredExpenses = expenses.take(4).toList();
            break;
          case 'Monthly':
            filteredExpenses = expenses.take(5).toList();
            break;
          case 'Yearly':
            filteredExpenses = expenses;
            break;
          default:
            filteredExpenses = expenses;
        }

        final total = filteredExpenses.fold(
          0.0,
          (sum, item) => sum + item.value,
        );

        emit(
          ExpensesLoaded(
            expenses: filteredExpenses,
            totalValue: total,
            activeCategory: event.category,
            categories:
                currentState.categories, // Giữ nguyên danh sách categories
          ),
        );
      } catch (e) {
        emit(ExpensesError(e.toString()));
      }
    }
  }

  void _onSearchExpenses(
    SearchExpenses event,
    Emitter<ExpensesState> emit,
  ) async {
    if (state is ExpensesLoaded) {
      final currentState = state as ExpensesLoaded;

      if (event.query.isEmpty) {
        // Nếu query rỗng, trả về toàn bộ expenses theo category hiện tại
        add(FilterExpensesByCategory(currentState.activeCategory));
        return;
      }

      emit(ExpensesLoading());

      try {
        // Giả lập tìm kiếm
        await Future.delayed(const Duration(milliseconds: 300));

        final searchResults = expenses
            .where(
              (expense) => expense.name.toLowerCase().contains(
                event.query.toLowerCase(),
              ),
            )
            .toList();

        final total = searchResults.fold(0.0, (sum, item) => sum + item.value);

        emit(
          ExpensesLoaded(
            expenses: searchResults,
            totalValue: total,
            activeCategory: currentState.activeCategory,
            categories:
                currentState.categories, // Giữ nguyên danh sách categories
          ),
        );
      } catch (e) {
        emit(ExpensesError(e.toString()));
      }
    }
  }
}
