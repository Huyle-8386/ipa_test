import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';

abstract class MoneySourceRepository {
  Future<List<MoneySourceEntity>> getMoneySources();
}
