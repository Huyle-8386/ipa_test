import 'package:fintrack/features/income/domain/usecases/get_income_categories_usecase.dart';
import 'package:fintrack/features/income/domain/usecases/get_income_usecase.dart';
import 'package:fintrack/features/income/domain/usecases/search_income_usecase.dart';
import 'package:fintrack/features/income/domain/usecases/get_previous_income_usecase.dart';
import 'package:fintrack/features/income/presentation/bloc/income_event.dart';
import 'package:fintrack/features/income/presentation/bloc/income_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  final GetIncomeUsecase getIncome;
  final GetIncomeCategoriesUsecase getCategories;
  final SearchIncomeUsecase searchIncome;
  final GetPreviousIncomeUsecase getPreviousIncome;

  IncomeBloc({
    required this.getIncome,
    required this.getCategories,
    required this.searchIncome,
    required this.getPreviousIncome,
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
      final prevIncomes = await getPreviousIncome(category: defaultCategory);
      // build map of previous sums per categoryId
      final Map<String, double> prevSums = {};
      for (var e in prevIncomes) {
        final key = e.categoryId;
        prevSums[key] = (prevSums[key] ?? 0.0) + e.amount;
      }
      final total = allIncomes.fold(0.0, (sum, item) => sum + item.amount);
      final prevTotal = prevIncomes.fold(0.0, (sum, item) => sum + item.amount);
      final diff = total - prevTotal;
      final isIncrease = diff >= 0;

      emit(
        IncomeLoaded(
          incomes: allIncomes,
          totalValue: total,
          previousTotal: prevTotal,
          previousSums: prevSums,
          diff: diff,
          isIncrease: isIncrease,
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
        final prevIncomes = await getPreviousIncome(category: event.category);
        final Map<String, double> prevSums = {};
        for (var e in prevIncomes) {
          final key = e.categoryId;
          prevSums[key] = (prevSums[key] ?? 0.0) + e.amount;
        }
        final total = filteredIncomes.fold(
          0.0,
          (sum, item) => sum + item.amount,
        );
        final prevTotal = prevIncomes.fold(
          0.0,
          (sum, item) => sum + item.amount,
        );
        final diff = total - prevTotal;
        final isIncrease = diff >= 0;

        emit(
          IncomeLoaded(
            incomes: filteredIncomes,
            totalValue: total,
            previousTotal: prevTotal,
            previousSums: prevSums,
            diff: diff,
            isIncrease: isIncrease,
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
        final prevIncomes = await getPreviousIncome(
          category: currentState.activeCategory,
        );
        final Map<String, double> prevSums = {};
        for (var e in prevIncomes) {
          final key = e.categoryId;
          prevSums[key] = (prevSums[key] ?? 0.0) + e.amount;
        }
        final total = searchResults.fold(0.0, (sum, item) => sum + item.amount);
        final prevTotal = prevIncomes.fold(
          0.0,
          (sum, item) => sum + item.amount,
        );
        final diff = total - prevTotal;
        final isIncrease = diff >= 0;

        emit(
          IncomeLoaded(
            incomes: searchResults,
            totalValue: total,
            previousTotal: prevTotal,
            previousSums: prevSums,
            diff: diff,
            isIncrease: isIncrease,
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
