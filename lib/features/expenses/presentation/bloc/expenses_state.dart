import 'package:equatable/equatable.dart';
import 'package:fintrack/features/expenses/domain/entities/expense_entity.dart';

abstract class ExpensesState extends Equatable {
  const ExpensesState();

  @override
  List<Object> get props => [];
}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoading extends ExpensesState {}

class ExpensesLoaded extends ExpensesState {
  final List<ExpenseEntity> expenses;
  final double totalValue;
  final double previousTotal;
  final double diff; // totalValue - previousTotal
  final bool isIncrease;
  final String activeCategory;
  final List<String> categories;

  const ExpensesLoaded({
    required this.expenses,
    required this.totalValue,
    required this.previousTotal,
    required this.diff,
    required this.isIncrease,
    required this.activeCategory,
    required this.categories,
  });

  @override
  List<Object> get props => [
    expenses,
    totalValue,
    previousTotal,
    diff,
    isIncrease,
    activeCategory,
    categories,
  ];
}

class ExpensesError extends ExpensesState {
  final String message;

  const ExpensesError(this.message);

  @override
  List<Object> get props => [message];
}
