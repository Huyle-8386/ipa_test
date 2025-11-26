import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fintrack/features/add_transaction/domain/usecases/upload_image_usecase.dart';
import 'package:fintrack/features/add_transaction/domain/usecases/sync_is_income_usecase.dart';
import 'package:fintrack/features/add_transaction/domain/usecases/update_budgets_with_transaction_usecase.dart';
import 'image_entry_event.dart';
import 'image_entry_state.dart';

class ImageEntryBloc extends Bloc<ImageEntryEvent, ImageEntryState> {
  final UploadImageUsecase uploadImageUsecase;
  final SyncIsIncomeUseCase syncIsIncomeUseCase;
  final UpdateBudgetsWithTransactionUsecase updateBudgetsWithTransactionUsecase;
  final FirebaseAuth auth;

  ImageEntryBloc({
    required this.uploadImageUsecase,
    required this.syncIsIncomeUseCase,
    required this.updateBudgetsWithTransactionUsecase,
    required this.auth,
  }) : super(ImageEntryInitial()) {
    on<UploadImageRequested>(_onUploadImageRequested);
  }

  Future<void> _onUploadImageRequested(
    UploadImageRequested event,
    Emitter<ImageEntryState> emit,
  ) async {
    final userId = auth.currentUser?.uid;
    if (userId == null) {
      emit(ImageEntryFailure('User not logged in'));
      return;
    }

    emit(ImageEntryUploading());
    try {
      final result = await uploadImageUsecase(
        image: event.image,
        userId: userId,
        moneySources: event.moneySources,
      );
      await result.fold<Future<void>>(
        (failure) async => emit(ImageEntryFailure(failure.message)),
        (tx) async {
          await syncIsIncomeUseCase(tx);
          await updateBudgetsWithTransactionUsecase(tx);
          emit(ImageEntryUploadSuccess(tx));
        },
      );
    } catch (e) {
      emit(ImageEntryFailure(e.toString()));
    }
  }
}
