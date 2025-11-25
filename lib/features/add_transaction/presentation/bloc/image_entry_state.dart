import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';

abstract class ImageEntryState {}

class ImageEntryInitial extends ImageEntryState {}

class ImageEntryUploading extends ImageEntryState {}

class ImageEntryUploadSuccess extends ImageEntryState {
  final TransactionEntity transaction;

  ImageEntryUploadSuccess(this.transaction);
}

class ImageEntryFailure extends ImageEntryState {
  final String message;

  ImageEntryFailure(this.message);
}
