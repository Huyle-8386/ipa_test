import 'package:equatable/equatable.dart';
import 'package:fintrack/features/budget/models/budget_model.dart';

class BudgetState extends Equatable {
  final String selectedTab;
  final List<BudgetModel> budgets;
  final bool isLoading;

  final BudgetModel? selectedBudget;

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
    List<BudgetModel>? budgets,
    bool? isLoading,
    BudgetModel? selectedBudget,
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
