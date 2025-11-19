import 'package:fintrack/features/transaction_%20history/domain/entities/transaction_entity.dart';
import 'package:fintrack/features/transaction_%20history/domain/repositories/transaction_history_repository.dart';

class GetTransactionsUsecase {
  final TransactionHistoryRepository repository;

  GetTransactionsUsecase(this.repository);

  Future<List<TransactionEntity>> call({
    TransactionType type = TransactionType.all,
  }) {
    return repository.getTransactions(type: type);
  }
}
