import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/image_entry_repository.dart';

class SyncIsIncomeUseCase {
  final ImageEntryRepository repository;

  SyncIsIncomeUseCase(this.repository);

  Future<void> call(TransactionEntity tx) {
    return repository.syncIsIncomeIfNeeded(tx);
  }
}
