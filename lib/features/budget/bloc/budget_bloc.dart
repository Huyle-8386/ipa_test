import 'package:fintrack/features/budget/datasources/budget_datasource.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc() : super(BudgetState.initial()) {
    on<LoadBudgets>(_onLoadBudgets);
    on<BudgetTabChanged>(_onTabChanged);
    on<SelectBudget>(_onSelectBudget);
  }

  void _onLoadBudgets(LoadBudgets event, Emitter<BudgetState> emit) {
    final filtered = BudgetDataSource.budgets
        .where((b) => state.selectedTab == "Active" ? b.isActive : !b.isActive)
        .toList();

    emit(state.copyWith(budgets: filtered, isLoading: false));
  }

  void _onTabChanged(BudgetTabChanged event, Emitter<BudgetState> emit) {
    final filtered = BudgetDataSource.budgets
        .where((b) => event.selectedTab == "Active" ? b.isActive : !b.isActive)
        .toList();

    emit(state.copyWith(selectedTab: event.selectedTab, budgets: filtered));
  }

  void _onSelectBudget(SelectBudget event, Emitter<BudgetState> emit) {
    emit(state.copyWith(selectedBudget: event.budget));
  }
}
