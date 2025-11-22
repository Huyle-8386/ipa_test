import 'package:fintrack/features/transaction_%20history/data/datasources/transaction_history_local_ds.dart';
import 'package:fintrack/features/transaction_%20history/data/models/transaction_model.dart';
import 'package:fintrack/features/transaction_%20history/domain/entities/transaction_entity.dart';
import 'package:fintrack/features/transaction_%20history/domain/repositories/transaction_history_repository.dart';

class TransactionHistoryRepositoryImpl implements TransactionHistoryRepository {
  final TransactionHistoryLocalDataSource localDataSource;

  TransactionHistoryRepositoryImpl({required this.localDataSource});

  List<TransactionEntity> _map(List<TransactionModel> models) => models;

  @override
  Future<List<String>> getFilterTypes() => localDataSource.getFilterTypes();

  @override
  Future<List<TransactionEntity>> getTransactions({
    TransactionType type = TransactionType.all,
  }) async {
    final models = await localDataSource.getTransactionsByType(type);
    return _map(models);
  }

  @override
  Future<List<TransactionEntity>> searchTransactions(
    String query, {
    TransactionType type = TransactionType.all,
  }) async {
    final models = await localDataSource.searchTransactions(query, type: type);
    return _map(models);
  }
}
