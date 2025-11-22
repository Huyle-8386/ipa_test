part of 'money_source_bloc.dart';

abstract class MoneySourceState {}

class MoneySourceInitial extends MoneySourceState {}

class MoneySourceLoading extends MoneySourceState {}

class MoneySourceLoaded extends MoneySourceState {
  final List<MoneySourceEntity> list;

  MoneySourceLoaded(this.list);
}

class MoneySourceError extends MoneySourceState {
  final String message;

  MoneySourceError(this.message);
}
