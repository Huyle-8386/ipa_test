import 'dart:io';

import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';

abstract class ImageEntryEvent {}

class UploadImageRequested extends ImageEntryEvent {
  final File image;
  final List<MoneySourceEntity> moneySources;

  UploadImageRequested({
    required this.image,
    required this.moneySources,
  });
}
