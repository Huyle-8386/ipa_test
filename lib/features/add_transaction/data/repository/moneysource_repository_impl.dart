import 'package:fintrack/features/add_transaction/data/datasource/%20moneysource_remote_datasource.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/%20moneysource_repository.dart';

class MoneySourceRepositoryImpl implements MoneySourceRepository {
  final MoneySourceRemoteDataSource remote;

  MoneySourceRepositoryImpl(this.remote);

  @override
  Future<List<MoneySourceEntity>> getMoneySources() {
    return remote.getMoneySources();
  }
}
