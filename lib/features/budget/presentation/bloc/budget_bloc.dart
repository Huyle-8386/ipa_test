// lib/features/budget/presentation/bloc/budget_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/budget_repository.dart';
import '../../domain/usecases/get_budgets.dart';
import '../../domain/entities/budget_entity.dart';
import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final GetBudgets getBudgets;

  BudgetBloc({required this.getBudgets}) : super(BudgetState.initial()) {
    on<LoadBudgets>(_onLoadBudgets);
    on<BudgetTabChanged>(_onTabChanged);
    on<SelectBudgetEvent>(_onSelectBudget);
  }

  Future<void> _onLoadBudgets(
    LoadBudgets event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final all = await getBudgets();
    final filtered = _filterByTab(all, state.selectedTab);
    emit(state.copyWith(budgets: filtered, isLoading: false));
  }

  void _onTabChanged(BudgetTabChanged event, Emitter<BudgetState> emit) {
    final filtered = _filterByTab(
      state.budgets.isEmpty ? [] : state.budgets,
      event.selectedTab,
    );
    // If budgets not loaded yet, try to load all then filter (we'll be conservative)
    emit(
      state.copyWith(
        selectedTab: event.selectedTab,
        budgets: state.budgets.isEmpty ? [] : filtered,
      ),
    );
  }

  void _onSelectBudget(SelectBudgetEvent event, Emitter<BudgetState> emit) {
    emit(state.copyWith(selectedBudget: event.budget));
  }

  List<BudgetEntity> _filterByTab(List<BudgetEntity> items, String tab) {
    if (items.isEmpty) return items;
    if (tab == "Active") {
      return items.where((b) => b.isActive).toList();
    } else {
      return items.where((b) => !b.isActive).toList();
    }
  }
}
