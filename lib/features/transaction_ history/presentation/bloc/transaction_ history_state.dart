import 'package:equatable/equatable.dart';
import 'package:fintrack/features/transaction_%20history/data/datasources/transaction_%20history_data.dart';

abstract class TransactionHistoryState extends Equatable {
  const TransactionHistoryState();

  @override
  List<Object> get props => [];
}

class TransactionHistoryInitial extends TransactionHistoryState {}

class TransactionHistoryLoading extends TransactionHistoryState {}

class TransactionHistoryLoaded extends TransactionHistoryState {
  final List<TransactionData> transactions;
  final Map<String, List<TransactionData>> groupedTransactions;
  final TransactionType activeFilter;
  final double totalIncome;
  final double totalSpending;
  final double balance;

  const TransactionHistoryLoaded({
    required this.transactions,
    required this.groupedTransactions,
    required this.activeFilter,
    required this.totalIncome,
    required this.totalSpending,
    required this.balance,
  });

  @override
  List<Object> get props => [
    transactions,
    groupedTransactions,
    activeFilter,
    totalIncome,
    totalSpending,
    balance,
  ];
}

class TransactionHistoryError extends TransactionHistoryState {
  final String message;

  const TransactionHistoryError(this.message);

  @override
  List<Object> get props => [message];
}
