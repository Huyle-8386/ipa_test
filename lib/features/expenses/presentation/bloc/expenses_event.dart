import 'package:equatable/equatable.dart';

abstract class ExpensesEvent extends Equatable {
  const ExpensesEvent();

  @override
  List<Object> get props => [];
}

class LoadExpensesData extends ExpensesEvent {}

class FilterExpensesByCategory extends ExpensesEvent {
  final String category;

  const FilterExpensesByCategory(this.category);

  @override
  List<Object> get props => [category];
}

class SearchExpenses extends ExpensesEvent {
  final String query;

  const SearchExpenses(this.query);

  @override
  List<Object> get props => [query];
}
