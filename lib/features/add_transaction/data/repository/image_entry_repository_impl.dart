import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fintrack/core/error/failure.dart';
import 'package:fintrack/features/add_transaction/data/datasource/image_entry_remote_datasource.dart';
import 'package:fintrack/features/add_transaction/data/model/transaction_model.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/image_entry_repository.dart';

class ImageEntryRepositoryImpl implements ImageEntryRepository {
  final ImageEntryRemoteDataSource remoteDataSource;

  ImageEntryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TransactionEntity>> uploadImage(
    File file,
    String userId,
    List<MoneySourceEntity> moneySources,
  ) async {
    final serializedSources = moneySources
        .map((e) => {'id': e.id, 'name': e.name})
        .toList();

    try {
      final TransactionModel model = await remoteDataSource.uploadImage(
        image: file,
        userId: userId,
        moneySources: serializedSources,
      );

      return Right(model.toEntity());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<void> syncIsIncomeIfNeeded(TransactionEntity tx) {
    return remoteDataSource.syncIsIncomeIfNeeded(tx);
  }
}
