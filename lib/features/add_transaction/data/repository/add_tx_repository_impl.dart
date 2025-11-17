import 'package:fintrack/features/add_transaction/data/datasource/add_tx_local_ds.dart';
import 'package:fintrack/features/add_transaction/data/model/transaction_model.dart';
import 'package:fintrack/features/add_transaction/domain/entities/category_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/add_tx_repository.dart';

class AddTxRepositoryImpl implements AddTxRepository {
  final AddTxLocalDataSource local;

  AddTxRepositoryImpl(this.local);

  @override
  Future<List<CategoryEntity>> getCategories({required bool isIncome}) {
    return local.getCategories(isIncome: isIncome);
  }

  @override
  Future<List<MoneySourceEntity>> getMoneySources() {
    return local.getMoneySources();
  }

  @override
  Future<void> saveTransaction(TransactionEntity tx) {
    final model = TransactionModel(
      id: tx.id,
      amount: tx.amount,
      dateTime: tx.dateTime,
      note: tx.note,
      category: tx.category as dynamic, // đã là model ở local mock
      moneySource: tx.moneySource as dynamic,
      isIncome: tx.isIncome,
    );
    return local.saveTransaction(model);
  }
}
