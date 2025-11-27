import 'package:dartz/dartz.dart';
import 'package:fintrack/core/error/failure.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';

abstract class MoneySourceRepository {
  Future<List<MoneySourceEntity>> getMoneySources();
  Future<void> changeBalance(String moneySourceId, double delta);
  Future<Either<Failure, MoneySourceEntity>> getById(String id);
}
