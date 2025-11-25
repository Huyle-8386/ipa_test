import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fintrack/core/error/failure.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';

abstract class ImageEntryRepository {
  Future<Either<Failure, TransactionEntity>> uploadImage(
    File file,
    String userId,
    List<MoneySourceEntity> moneySources,
  );
}
