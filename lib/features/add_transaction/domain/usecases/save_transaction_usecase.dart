import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/add_tx_repository.dart';

class SaveTransactionUsecase {
  final AddTxRepository repo;

  SaveTransactionUsecase(this.repo);

  Future<void> call(TransactionEntity tx) async {
    return repo.saveTransaction(tx);
  }
}
