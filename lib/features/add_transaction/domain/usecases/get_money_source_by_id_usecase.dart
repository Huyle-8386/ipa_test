import 'package:dartz/dartz.dart';
import 'package:fintrack/core/error/failure.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/%20moneysource_repository.dart';

class GetMoneySourceByIdUseCase {
  final MoneySourceRepository repository;

  GetMoneySourceByIdUseCase(this.repository);

  Future<Either<Failure, MoneySourceEntity>> call(String id) {
    return repository.getById(id);
  }
}
