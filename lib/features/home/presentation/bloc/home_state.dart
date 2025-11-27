import 'package:fintrack/features/chart/domain/entities/money_source_entity.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String userName;
  final double totalBalance;
  final List<MoneySourceEntity> moneySources;

  HomeLoaded({
    required this.userName,
    required this.totalBalance,
    required this.moneySources,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}
