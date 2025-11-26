import '../datasource/money_source_remote_data_source.dart';
import '../../domain/entities/money_source_entity.dart';
import '../../domain/repositories/money_source_repository.dart';

class MoneySourceRepositoryImpl implements MoneySourceRepository {
  final MoneySourceRemoteDataSource remote;

  MoneySourceRepositoryImpl(this.remote);

  @override
  Future<void> addMoneySource(String uid, MoneySourceEntity entity) =>
      remote.addMoneySource(uid, entity);

  @override
  Future<void> deleteMoneySource(String uid, String id) =>
      remote.deleteMoneySource(uid, id);

  @override
  Future<List<MoneySourceEntity>> getMoneySources(String uid) =>
      remote.getMoneySources(uid);

  @override
  Future<void> updateMoneySource(String uid, MoneySourceEntity entity) =>
      remote.updateMoneySource(uid, entity);
}
