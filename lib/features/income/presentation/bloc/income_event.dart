import 'package:equatable/equatable.dart';

abstract class IncomeEvent extends Equatable {
  const IncomeEvent();

  @override
  List<Object> get props => [];
}

class LoadIncomeData extends IncomeEvent {}

class FilterIncomeByCategory extends IncomeEvent {
  final String category;

  const FilterIncomeByCategory(this.category);

  @override
  List<Object> get props => [category];
}

class SearchIncome extends IncomeEvent {
  final String query;

  const SearchIncome(this.query);

  @override
  List<Object> get props => [query];
}
