import 'package:equatable/equatable.dart';
import 'package:fintrack/features/transaction_%20history/domain/entities/transaction_entity.dart';

abstract class TransactionHistoryEvent extends Equatable {
  const TransactionHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadTransactionHistory extends TransactionHistoryEvent {}

class FilterTransactionsByType extends TransactionHistoryEvent {
  final TransactionType type;

  const FilterTransactionsByType(this.type);

  @override
  List<Object> get props => [type];
}

class SearchTransactions extends TransactionHistoryEvent {
  final String query;

  const SearchTransactions(this.query);

  @override
  List<Object> get props => [query];
}
