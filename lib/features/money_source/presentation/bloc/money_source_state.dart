import 'package:equatable/equatable.dart';
import '../../domain/entities/money_source_entity.dart';

abstract class MoneySourceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MoneySourceInitial extends MoneySourceState {}

class MoneySourceLoading extends MoneySourceState {}

class MoneySourceLoaded extends MoneySourceState {
  final List<MoneySourceEntity> moneySources;
  MoneySourceLoaded(this.moneySources);
  @override
  List<Object?> get props => [moneySources];
}

class MoneySourceError extends MoneySourceState {
  final String message;
  MoneySourceError(this.message);
  @override
  List<Object?> get props => [message];
}
