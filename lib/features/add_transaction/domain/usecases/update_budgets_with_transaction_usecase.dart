import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/add_tx_repository.dart';

class UpdateBudgetsWithTransactionUsecase {
  final AddTxRepository repository;

  UpdateBudgetsWithTransactionUsecase(this.repository);

  Future<void> call(TransactionEntity tx) {
    return repository.updateBudgetsWithTransaction(tx);
  }
}
