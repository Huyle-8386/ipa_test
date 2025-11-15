// lib/features/budget/presentation/bloc/budget_event.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/budget_entity.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

class LoadBudgets extends BudgetEvent {
  const LoadBudgets();
}

class BudgetTabChanged extends BudgetEvent {
  final String selectedTab;
  const BudgetTabChanged(this.selectedTab);

  @override
  List<Object?> get props => [selectedTab];
}

class SelectBudgetEvent extends BudgetEvent {
  final BudgetEntity budget;
  const SelectBudgetEvent(this.budget);

  @override
  List<Object?> get props => [budget];
}
