import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_data_source.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remote;

  TransactionRepositoryImpl({required this.remote});

  @override
  Future<List<TransactionEntity>> getTransactions() {
    return remote.getTransactions();
  }
}
