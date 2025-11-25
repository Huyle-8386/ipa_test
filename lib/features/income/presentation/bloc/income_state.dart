import 'package:equatable/equatable.dart';
import 'package:fintrack/features/income/domain/entities/income_entity.dart';

abstract class IncomeState extends Equatable {
  const IncomeState();

  @override
  List<Object> get props => [];
}

class IncomeInitial extends IncomeState {}

class IncomeLoading extends IncomeState {}

class IncomeLoaded extends IncomeState {
  final List<IncomeEntity> incomes;
  final double totalValue;
  final double previousTotal;
  final Map<String, double>
  previousSums; // categoryId -> amount in previous period
  final double diff;
  final bool isIncrease;
  final String activeCategory;
  final List<String> categories;

  const IncomeLoaded({
    required this.incomes,
    required this.totalValue,
    required this.previousTotal,
    required this.previousSums,
    required this.diff,
    required this.isIncrease,
    required this.activeCategory,
    required this.categories,
  });

  @override
  List<Object> get props => [
    incomes,
    totalValue,
    previousTotal,
    previousSums,
    diff,
    isIncrease,
    activeCategory,
    categories,
  ];
}

class IncomeError extends IncomeState {
  final String message;

  const IncomeError(this.message);

  @override
  List<Object> get props => [message];
}
