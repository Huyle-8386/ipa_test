import 'package:fintrack/features/expenses/domain/usecases/get_categories_usecase.dart';
import 'package:fintrack/features/expenses/domain/usecases/get_expenses_usecase.dart';
import 'package:fintrack/features/expenses/domain/usecases/search_expenses_usecase.dart';
import 'package:fintrack/features/expenses/presentation/bloc/expenses_event.dart';
import 'package:fintrack/features/expenses/presentation/bloc/expenses_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final GetExpensesUsecase getExpenses;
  final GetCategoriesUsecase getCategories;
  final SearchExpensesUsecase searchExpenses;

  ExpensesBloc({
    required this.getExpenses,
    required this.getCategories,
    required this.searchExpenses,
  }) : super(ExpensesInitial()) {
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
      final allCategories = await getCategories();
      final defaultCategory = allCategories.first;
      final allExpenses = await getExpenses(category: defaultCategory);
      final total = allExpenses.fold(0.0, (sum, item) => sum + item.value);

      emit(
        ExpensesLoaded(
          expenses: allExpenses,
          totalValue: total,
          activeCategory: defaultCategory,
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
        final filteredExpenses = await getExpenses(category: event.category);
        final total = filteredExpenses.fold(
          0.0,
          (sum, item) => sum + item.value,
        );

        emit(
          ExpensesLoaded(
            expenses: filteredExpenses,
            totalValue: total,
            activeCategory: event.category,
            categories: currentState.categories,
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
        final searchResults = await searchExpenses(query: event.query);
        final total = searchResults.fold(0.0, (sum, item) => sum + item.value);

        emit(
          ExpensesLoaded(
            expenses: searchResults,
            totalValue: total,
            activeCategory: currentState.activeCategory,
            categories: currentState.categories,
          ),
        );
      } catch (e) {
        emit(ExpensesError(e.toString()));
      }
    }
  }
}
