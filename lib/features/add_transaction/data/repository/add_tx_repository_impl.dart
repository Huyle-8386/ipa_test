import 'package:fintrack/features/add_transaction/data/datasource/add_tx_remote_datasource.dart';

import 'package:fintrack/features/add_transaction/data/model/transaction_model.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/add_tx_repository.dart';

class AddTxRepositoryImpl implements AddTxRepository {
  final AddTxRemoteDataSource remote;

  AddTxRepositoryImpl(this.remote);

  @override
  Future<String> saveTransaction(TransactionEntity tx) async {
    final model = TransactionModel.fromEntity(tx);
    return remote.saveTransaction(model);
  }

  @override
  Future<void> deleteTransactionWithBalance({
    required String id,
    required String moneySourceId,
    required double amount,
    required bool isIncome,
  }) {
    return remote.deleteTransactionWithBalance(
      id: id,
      moneySourceId: moneySourceId,
      amount: amount,
      isIncome: isIncome,
    );
  }

  @override
  Future<void> updateTransactionWithBalance({
    required TransactionEntity oldTx,
    required TransactionEntity newTx,
  }) {
    final oldModel = TransactionModel.fromEntity(oldTx);
    final newModel = TransactionModel.fromEntity(newTx);
    return remote.updateTransactionWithBalance(
      oldModel: oldModel,
      newModel: newModel,
    );
  }

  @override
  Future<void> updateBudgetsWithTransaction(TransactionEntity tx) {
    final model = TransactionModel.fromEntity(tx);
    return remote.updateBudgetsWithTransaction(model);
  }
}
