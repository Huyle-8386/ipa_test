import 'package:fintrack/features/income/domain/usecases/get_income_categories_usecase.dart';
import 'package:fintrack/features/income/domain/usecases/get_income_usecase.dart';
import 'package:fintrack/features/income/domain/usecases/search_income_usecase.dart';
import 'package:fintrack/features/income/presentation/bloc/income_event.dart';
import 'package:fintrack/features/income/presentation/bloc/income_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  final GetIncomeUsecase getIncome;
  final GetIncomeCategoriesUsecase getCategories;
  final SearchIncomeUsecase searchIncome;

  IncomeBloc({
    required this.getIncome,
    required this.getCategories,
    required this.searchIncome,
  }) : super(IncomeInitial()) {
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
      final allCategories = await getCategories();
      final defaultCategory = allCategories.first;
      final allIncomes = await getIncome(category: defaultCategory);
      final total = allIncomes.fold(0.0, (sum, item) => sum + item.value);

      emit(
        IncomeLoaded(
          incomes: allIncomes,
          totalValue: total,
          activeCategory: defaultCategory, // Default là phần tử đầu
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
        final filteredIncomes = await getIncome(category: event.category);
        final total = filteredIncomes.fold(
          0.0,
          (sum, item) => sum + item.value,
        );

        emit(
          IncomeLoaded(
            incomes: filteredIncomes,
            totalValue: total,
            activeCategory: event.category,
            categories: currentState.categories,
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
        final searchResults = await searchIncome(query: event.query);
        final total = searchResults.fold(0.0, (sum, item) => sum + item.value);

        emit(
          IncomeLoaded(
            incomes: searchResults,
            totalValue: total,
            activeCategory: currentState.activeCategory,
            categories: currentState.categories,
          ),
        );
      } catch (e) {
        emit(IncomeError(e.toString()));
      }
    }
  }
}
