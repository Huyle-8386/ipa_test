import 'package:equatable/equatable.dart';
import '../../domain/entities/budget_entity.dart';

class BudgetState extends Equatable {
  final String selectedTab;
  final List<BudgetEntity> budgets;
  final bool loading;
  final bool addSuccess;
  final bool updateSuccess;
  final String? error;

  final String addAmount;
  final String addName;
  final String? addCategory;
  final String? addSource;
  final DateTime addStartDate;
  final DateTime addEndDate;
  final bool addIsActive;
  final String addSpent;

  const BudgetState({
    required this.selectedTab,
    required this.budgets,
    this.loading = false,
    this.addSuccess = false,
    this.updateSuccess = false,
    this.error,
    this.addAmount = "",
    this.addName = "",
    this.addCategory,
    this.addSource,
    required this.addStartDate,
    required this.addEndDate,
    this.addIsActive = true,
    this.addSpent = "",
  });

  factory BudgetState.initial() => BudgetState(
    selectedTab: "Active",
    budgets: [],
    loading: false,
    addSuccess: false,
    updateSuccess: false,
    error: null,
    addAmount: "",
    addName: "",
    addCategory: null,
    addSource: null,
    addStartDate: DateTime.now(),
    addEndDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
    addIsActive: true,
    addSpent: "",
  );

  BudgetState copyWith({
    String? selectedTab,
    List<BudgetEntity>? budgets,
    bool? loading,
    bool? addSuccess,
    bool? updateSuccess,
    String? error,
    String? addAmount,
    String? addName,
    String? addCategory,
    String? addSource,
    DateTime? addStartDate,
    DateTime? addEndDate,
    bool? addIsActive,
    String? addSpent,
  }) {
    return BudgetState(
      selectedTab: selectedTab ?? this.selectedTab,
      budgets: budgets ?? this.budgets,
      loading: loading ?? this.loading,
      addSuccess: addSuccess ?? this.addSuccess,
      updateSuccess: updateSuccess ?? this.updateSuccess,
      error: error,
      addAmount: addAmount ?? this.addAmount,
      addName: addName ?? this.addName,
      addCategory: addCategory ?? this.addCategory,
      addSource: addSource ?? this.addSource,
      addStartDate: addStartDate ?? this.addStartDate,
      addEndDate: addEndDate ?? this.addEndDate,
      addIsActive: addIsActive ?? this.addIsActive,
      addSpent: addSpent ?? this.addSpent,
    );
  }

  @override
  List<Object?> get props => [
    selectedTab,
    budgets,
    loading,
    addSuccess,
    updateSuccess,
    error,
    addAmount,
    addName,
    addCategory,
    addSource,
    addStartDate,
    addEndDate,
    addIsActive,
    addSpent,
  ];
}
