import 'package:dartz/dartz.dart';
import 'package:fintrack/core/error/failure.dart';

import '../repositories/money_source_repository.dart';

class CheckUserHasMoneySourceUseCase {
  final MoneySourceRepository repository;

  CheckUserHasMoneySourceUseCase(this.repository);

  Future<Either<Failure, bool>> call(String uid) async {
    try {
      final hasSources = await repository.hasMoneySources(uid);
      return Right(hasSources);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
