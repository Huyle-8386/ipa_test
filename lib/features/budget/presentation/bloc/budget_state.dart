// lib/features/budget/presentation/bloc/budget_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/budget_entity.dart';

class BudgetState extends Equatable {
  final String selectedTab;
  final List<BudgetEntity> budgets;
  final bool isLoading;
  final BudgetEntity? selectedBudget;

  const BudgetState({
    required this.selectedTab,
    required this.budgets,
    this.isLoading = false,
    this.selectedBudget,
  });

  factory BudgetState.initial() => const BudgetState(
    selectedTab: "Active",
    budgets: [],
    isLoading: true,
    selectedBudget: null,
  );

  BudgetState copyWith({
    String? selectedTab,
    List<BudgetEntity>? budgets,
    bool? isLoading,
    BudgetEntity? selectedBudget,
  }) {
    return BudgetState(
      selectedTab: selectedTab ?? this.selectedTab,
      budgets: budgets ?? this.budgets,
      isLoading: isLoading ?? this.isLoading,
      selectedBudget: selectedBudget ?? this.selectedBudget,
    );
  }

  @override
  List<Object?> get props => [selectedTab, budgets, isLoading, selectedBudget];
}
