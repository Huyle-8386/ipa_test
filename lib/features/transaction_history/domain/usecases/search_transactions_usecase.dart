import 'package:fintrack/features/transaction_history/domain/entities/transaction_entity.dart';
import 'package:fintrack/features/transaction_history/domain/repositories/transaction_history_repository.dart';

class SearchTransactionsUsecase {
  final TransactionHistoryRepository repository;

  SearchTransactionsUsecase(this.repository);

  Future<List<TransactionEntity>> call(
    String query, {
    TransactionType type = TransactionType.all,
  }) {
    return repository.searchTransactions(query, type: type);
  }
}
