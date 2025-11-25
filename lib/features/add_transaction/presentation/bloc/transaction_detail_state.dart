import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';

class TransactionDetailState {
  final TransactionEntity transaction;
  final bool isDeleting;
  final bool deleted;
  final String? error;
  final MoneySourceEntity? moneySource;
  final bool isMoneySourceLoading;
  final String? moneySourceError;

  const TransactionDetailState({
    required this.transaction,
    this.isDeleting = false,
    this.deleted = false,
    this.error,
    this.moneySource,
    this.isMoneySourceLoading = false,
    this.moneySourceError,
  });

  TransactionDetailState copyWith({
    TransactionEntity? transaction,
    bool? isDeleting,
    bool? deleted,
    String? error,
    MoneySourceEntity? moneySource,
    bool? isMoneySourceLoading,
    String? moneySourceError,
  }) {
    return TransactionDetailState(
      transaction: transaction ?? this.transaction,
      isDeleting: isDeleting ?? this.isDeleting,
      deleted: deleted ?? this.deleted,
      error: error,
      moneySource: moneySource ?? this.moneySource,
      isMoneySourceLoading: isMoneySourceLoading ?? this.isMoneySourceLoading,
      moneySourceError: moneySourceError,
    );
  }
}
