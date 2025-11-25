import 'dart:io';

import 'package:fintrack/features/add_transaction/domain/entities/upload_image_result.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/image_entry_repository.dart';

class UploadImageUsecase {
  final ImageEntryRepository repository;

  UploadImageUsecase(this.repository);

  Future<UploadImageResult> call({
    required File image,
    required String userId,
    required List<MoneySourceEntity> moneySources,
  }) {
    return repository.uploadImage(image, userId, moneySources);
  }
}
