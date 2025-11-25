import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fintrack/core/error/failure.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/image_entry_repository.dart';

class UploadImageUsecase {
  final ImageEntryRepository repository;

  UploadImageUsecase(this.repository);

  Future<Either<Failure, TransactionEntity>> call({
    required File image,
    required String userId,
    required List<MoneySourceEntity> moneySources,
  }) {
    return repository.uploadImage(image, userId, moneySources);
  }
}
