import '../entities/money_source_entity.dart';

abstract class MoneySourceRepository {
  Future<List<MoneySourceEntity>> getMoneySources(String uid);
}
