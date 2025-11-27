import 'package:fintrack/features/transaction_history/domain/entities/transaction_entity.dart';

abstract class TransactionHistoryRepository {
  Future<List<TransactionEntity>> getTransactions({
    TransactionType type = TransactionType.all,
  });

  Future<List<TransactionEntity>> searchTransactions(
    String query, {
    TransactionType type = TransactionType.all,
  });

  Future<List<String>> getFilterTypes();
}
