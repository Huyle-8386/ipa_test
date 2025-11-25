import 'package:dartz/dartz.dart';
import 'package:fintrack/core/error/failure.dart';
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

  @override
  Future<void> changeBalance(String moneySourceId, double delta) {
    return remote.incrementBalance(moneySourceId: moneySourceId, delta: delta);
  }

  @override
  Future<Either<Failure, MoneySourceEntity>> getById(String id) async {
    try {
      final ms = await remote.getMoneySourceById(id);
      if (ms == null) {
        return const Left(Failure('Money source not found'));
      }
      return Right(ms);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
