import 'package:equatable/equatable.dart';
import 'package:fintrack/features/income/data/datasources/income_data.dart';

abstract class IncomeState extends Equatable {
  const IncomeState();

  @override
  List<Object> get props => [];
}

class IncomeInitial extends IncomeState {}

class IncomeLoading extends IncomeState {}

class IncomeLoaded extends IncomeState {
  final List<IncomeData> incomes;
  final double totalValue;
  final String activeCategory;
  final List<String> categories;

  const IncomeLoaded({
    required this.incomes,
    required this.totalValue,
    required this.activeCategory,
    required this.categories,
  });

  @override
  List<Object> get props => [incomes, totalValue, activeCategory, categories];
}

class IncomeError extends IncomeState {
  final String message;

  const IncomeError(this.message);

  @override
  List<Object> get props => [message];
}
