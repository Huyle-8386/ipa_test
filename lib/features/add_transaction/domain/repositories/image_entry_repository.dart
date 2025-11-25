import 'dart:io';

import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/upload_image_result.dart';

abstract class ImageEntryRepository {
  Future<UploadImageResult> uploadImage(
    File file,
    String userId,
    List<MoneySourceEntity> moneySources,
  );
}
