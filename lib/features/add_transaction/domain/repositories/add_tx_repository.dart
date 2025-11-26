import 'package:fintrack/features/add_transaction/domain/entities/category_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';

abstract class AddTxRepository {
  Future<String> saveTransaction(TransactionEntity tx);
  Future<void> deleteTransactionWithBalance({
    required String id,
    required String moneySourceId,
    required double amount,
    required bool isIncome,
  });
  Future<void> updateTransactionWithBalance({
    required TransactionEntity oldTx,
    required TransactionEntity newTx,
  });
  Future<void> updateBudgetsWithTransaction(TransactionEntity tx);
}
