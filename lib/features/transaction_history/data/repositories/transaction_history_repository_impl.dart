import 'package:fintrack/features/transaction_history/data/datasources/transaction_history_remote_ds.dart';
import 'package:fintrack/features/transaction_history/data/models/transaction_model.dart';
import 'package:fintrack/features/transaction_history/domain/entities/transaction_entity.dart';
import 'package:fintrack/features/transaction_history/domain/repositories/transaction_history_repository.dart';

class TransactionHistoryRepositoryImpl implements TransactionHistoryRepository {
  final TransactionHistoryRemoteDataSource remoteDataSource;

  TransactionHistoryRepositoryImpl({required this.remoteDataSource});

  List<TransactionEntity> _map(List<TransactionModel> models) => models;

  @override
  Future<List<String>> getFilterTypes() => remoteDataSource.getFilterTypes();

  @override
  Future<List<TransactionEntity>> getTransactions({
    TransactionType type = TransactionType.all,
  }) async {
    final models = await remoteDataSource.getTransactionsByType(type);
    return _map(models);
  }

  @override
  Future<List<TransactionEntity>> searchTransactions(
    String query, {
    TransactionType type = TransactionType.all,
  }) async {
    final models = await remoteDataSource.searchTransactions(query, type: type);
    return _map(models);
  }
}
