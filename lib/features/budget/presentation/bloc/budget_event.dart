// import 'package:equatable/equatable.dart';
// import '../../domain/entities/budget_entity.dart';

// abstract class BudgetEvent extends Equatable {
//   const BudgetEvent();

//   @override
//   List<Object?> get props => [];
// }

// class LoadBudgets extends BudgetEvent {
//   const LoadBudgets();
// }

// class BudgetTabChanged extends BudgetEvent {
//   final String selectedTab;
//   const BudgetTabChanged(this.selectedTab);

//   @override
//   List<Object?> get props => [selectedTab];
// }

// class SelectBudgetEvent extends BudgetEvent {
//   final BudgetEntity budget;
//   const SelectBudgetEvent(this.budget);

//   @override
//   List<Object?> get props => [budget];
// }

// class AddAmountChanged extends BudgetEvent {
//   final String amount;
//   const AddAmountChanged(this.amount);

//   @override
//   List<Object?> get props => [amount];
// }

// class AddNameChanged extends BudgetEvent {
//   final String name;
//   const AddNameChanged(this.name);

//   @override
//   List<Object?> get props => [name];
// }

// class AddCategoryChanged extends BudgetEvent {
//   final String category;
//   const AddCategoryChanged(this.category);

//   @override
//   List<Object?> get props => [category];
// }

// class AddSourceChanged extends BudgetEvent {
//   final String source;
//   const AddSourceChanged(this.source);

//   @override
//   List<Object?> get props => [source];
// }

// class AddStartDateChanged extends BudgetEvent {
//   final DateTime date;
//   const AddStartDateChanged(this.date);

//   @override
//   List<Object?> get props => [date];
// }

// class AddEndDateChanged extends BudgetEvent {
//   final DateTime date;
//   const AddEndDateChanged(this.date);

//   @override
//   List<Object?> get props => [date];
// }

import 'package:equatable/equatable.dart';
import '../../domain/entities/budget_entity.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();
  @override
  List<Object?> get props => [];
}

class BudgetTabChanged extends BudgetEvent {
  final String tab;

  const BudgetTabChanged(this.tab);

  @override
  List<Object?> get props => [tab];
}

class LoadBudgets extends BudgetEvent {
  final String uid;
  const LoadBudgets(this.uid);

  @override
  List<Object?> get props => [uid];
}

class AddBudgetRequested extends BudgetEvent {
  final String uid;
  const AddBudgetRequested(this.uid);

  @override
  List<Object?> get props => [uid];
}

class UpdateBudgetRequested extends BudgetEvent {
  final BudgetEntity budget;
  final String uid;
  const UpdateBudgetRequested(this.budget, this.uid);

  @override
  List<Object?> get props => [budget, uid];
}

class DeleteBudgetRequested extends BudgetEvent {
  final String budgetId;
  final String uid;
  const DeleteBudgetRequested(this.budgetId, this.uid);

  @override
  List<Object?> get props => [budgetId, uid];
}

//
// ─── FORM EVENTS ───────────────────────────────────────────────────────────────
//
class AddAmountChanged extends BudgetEvent {
  final String amount;
  const AddAmountChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

class AddNameChanged extends BudgetEvent {
  final String name;
  const AddNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class AddCategoryChanged extends BudgetEvent {
  final String categoryId;
  const AddCategoryChanged(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class AddSourceChanged extends BudgetEvent {
  final String sourceId;
  const AddSourceChanged(this.sourceId);

  @override
  List<Object?> get props => [sourceId];
}

class AddStartDateChanged extends BudgetEvent {
  final DateTime date;
  const AddStartDateChanged(this.date);

  @override
  List<Object?> get props => [date];
}

class AddEndDateChanged extends BudgetEvent {
  final DateTime date;
  const AddEndDateChanged(this.date);

  @override
  List<Object?> get props => [date];
}
