// import 'package:equatable/equatable.dart';
// import '../../domain/entities/budget_entity.dart';
// import '../../domain/entities/category_entity.dart';

// class BudgetState extends Equatable {
//   final String selectedTab;
//   final List<BudgetEntity> budgets;
//   final bool isLoading;
//   final BudgetEntity? selectedBudget;
//   // final List<CategoryEntity> categories;

//   final String addAmount;
//   final String addName;
//   final String? addCategory;
//   final String? addSource;
//   final DateTime addStartDate;
//   final DateTime addEndDate;

//   const BudgetState({
//     required this.selectedTab,
//     required this.budgets,
//     this.isLoading = false,
//     this.selectedBudget,
//     this.addAmount = "",
//     this.addName = "",
//     this.addCategory,
//     this.addSource,
//     required this.addStartDate,
//     required this.addEndDate,
//     // this.categories = const [],
//   });

//   factory BudgetState.initial() => BudgetState(
//     selectedTab: "Active",
//     budgets: [],
//     isLoading: true,
//     selectedBudget: null,
//     addAmount: "",
//     addName: "",
//     addCategory: null,
//     addSource: null,
//     addStartDate: DateTime.now(),
//     addEndDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
//   );

//   BudgetState copyWith({
//     String? selectedTab,
//     List<BudgetEntity>? budgets,
//     bool? isLoading,
//     BudgetEntity? selectedBudget,
//     // List<CategoryEntity>? categories,

//     // Add Budget Form
//     String? addAmount,
//     String? addName,
//     String? addCategory,
//     String? addSource,
//     DateTime? addStartDate,
//     DateTime? addEndDate,
//   }) {
//     return BudgetState(
//       selectedTab: selectedTab ?? this.selectedTab,
//       budgets: budgets ?? this.budgets,
//       isLoading: isLoading ?? this.isLoading,
//       selectedBudget: selectedBudget ?? this.selectedBudget,

//       // categories: categories ?? this.categories,
//       addAmount: addAmount ?? this.addAmount,
//       addName: addName ?? this.addName,
//       addCategory: addCategory ?? this.addCategory,
//       addSource: addSource ?? this.addSource,
//       addStartDate: addStartDate ?? this.addStartDate,
//       addEndDate: addEndDate ?? this.addEndDate,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     selectedTab,
//     budgets,
//     isLoading,
//     selectedBudget,

//     addAmount,
//     addName,
//     addCategory,
//     addSource,
//     addStartDate,
//     addEndDate,
//   ];
// }

import 'package:equatable/equatable.dart';
import '../../domain/entities/budget_entity.dart';

class BudgetState extends Equatable {
  final String selectedTab;
  final List<BudgetEntity> budgets;
  final bool loading;
  final bool addSuccess;
  final String? error;

  final String addAmount;
  final String addName;
  final String? addCategory;
  final String? addSource;
  final DateTime addStartDate;
  final DateTime addEndDate;

  const BudgetState({
    required this.selectedTab,
    required this.budgets,
    this.loading = false,
    this.addSuccess = false,
    this.error,
    this.addAmount = "",
    this.addName = "",
    this.addCategory,
    this.addSource,
    required this.addStartDate,
    required this.addEndDate,
  });

  factory BudgetState.initial() => BudgetState(
    selectedTab: "Active",
    budgets: [],
    loading: false,
    addSuccess: false,
    error: null,
    addAmount: "",
    addName: "",
    addCategory: null,
    addSource: null,
    addStartDate: DateTime.now(),
    addEndDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
  );

  BudgetState copyWith({
    String? selectedTab,
    List<BudgetEntity>? budgets,
    bool? loading,
    bool? addSuccess,
    String? error,
    String? addAmount,
    String? addName,
    String? addCategory,
    String? addSource,
    DateTime? addStartDate,
    DateTime? addEndDate,
  }) {
    return BudgetState(
      selectedTab: selectedTab ?? this.selectedTab,
      budgets: budgets ?? this.budgets,
      loading: loading ?? this.loading,
      addSuccess: addSuccess ?? this.addSuccess,
      error: error,
      addAmount: addAmount ?? this.addAmount,
      addName: addName ?? this.addName,
      addCategory: addCategory ?? this.addCategory,
      addSource: addSource ?? this.addSource,
      addStartDate: addStartDate ?? this.addStartDate,
      addEndDate: addEndDate ?? this.addEndDate,
    );
  }

  @override
  List<Object?> get props => [
    selectedTab,
    budgets,
    loading,
    addSuccess,
    error,
    addAmount,
    addName,
    addCategory,
    addSource,
    addStartDate,
    addEndDate,
  ];
}
