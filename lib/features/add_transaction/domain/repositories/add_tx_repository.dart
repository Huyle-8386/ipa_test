import 'package:fintrack/features/add_transaction/domain/entities/category_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';

abstract class AddTxRepository {
  Future<List<CategoryEntity>> getCategories({required bool isIncome});
  Future<List<MoneySourceEntity>> getMoneySources();
  Future<void> saveTransaction(TransactionEntity tx);
}
