



import 'package:fintrack/features/add_transaction/data/datasource/add_tx_remote_datasource.dart';
import 'package:fintrack/features/add_transaction/data/datasource/add_tx_remote_ds.dart';
import 'package:fintrack/features/add_transaction/data/model/transaction_model.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/add_tx_repository.dart';

class AddTxRepositoryImpl implements AddTxRepository {
  final AddTxRemoteDataSource remote;

  AddTxRepositoryImpl(this.remote);

  @override
  Future<void> saveTransaction(TransactionEntity tx) async {
    final model = TransactionModel.fromEntity(tx);
    await remote.saveTransaction(model);
  }
}