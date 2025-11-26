import '../entities/money_source_entity.dart';

abstract class MoneySourceRepository {
  Future<List<MoneySourceEntity>> getMoneySources(String uid);
  Future<void> addMoneySource(String uid, MoneySourceEntity entity);
  Future<void> updateMoneySource(String uid, MoneySourceEntity entity);
  Future<void> deleteMoneySource(String uid, String id);
}
