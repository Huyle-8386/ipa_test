import 'package:equatable/equatable.dart';
import 'package:fintrack/features/budget/models/budget_model.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

// đổi tab
class BudgetTabChanged extends BudgetEvent {
  final String selectedTab;
  const BudgetTabChanged(this.selectedTab);

  @override
  List<Object?> get props => [selectedTab];
}

// load dữ liệu
class LoadBudgets extends BudgetEvent {
  const LoadBudgets();
}

// chọn 1 budget để xem chi tiết
class SelectBudget extends BudgetEvent {
  final BudgetModel budget;
  const SelectBudget(this.budget);

  @override
  List<Object?> get props => [budget];
}
