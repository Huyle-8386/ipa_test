import 'package:fintrack/features/add_transaction/domain/entities/category_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/upload_image_result.dart';
import 'package:fintrack/features/add_transaction/domain/usecases/change_money_source_balance_usecase.dart';
import 'package:fintrack/features/add_transaction/domain/usecases/get_categories_usecase.dart';
import 'package:fintrack/features/add_transaction/domain/usecases/get_money_sources_usecase.dart';
import 'package:fintrack/features/add_transaction/domain/usecases/save_transaction_usecase.dart';
import 'package:fintrack/features/add_transaction/domain/usecases/upload_image_usecase.dart';
import 'package:fintrack/features/add_transaction/domain/usecases/update_transaction_usecase.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_event.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTxBloc extends Bloc<AddTxEvent, AddTxState> {
  final GetCategoriesUsecase getCategories;
  final GetMoneySourcesUsecase getMoneySources;
  final SaveTransactionUsecase saveTx;
  final UpdateTransactionUsecase updateTx;
  final ChangeMoneySourceBalanceUsecase changeBalance;
  final UploadImageUsecase uploadImage;

  AddTxBloc({
    required this.getCategories,
    required this.getMoneySources,
    required this.saveTx,
    required this.updateTx,
    required this.changeBalance,
    required this.uploadImage,
  }) : super(AddTxInitial()) {
    on<AddTxInitEvent>(_onInit);
    on<AddTxInitEditEvent>(_onInitEdit);
    on<AddTxTabChangedEvent>(_onTabChanged);
    on<AddTxTypeChangedEvent>(_onTypeChanged);
    on<AddTxCategorySelectedEvent>(_onCategory);
    on<AddTxMoneySourceChangedEvent>(_onMoneySource);
    on<AddTxAmountChangedEvent>(_onAmount);
    on<AddTxMerchantChangedEvent>(_onMerchant);
    on<AddTxDateChangedEvent>(_onDate);
    on<AddTxSubmitEvent>(_onSubmit);
    on<UploadImageEvent>(_onUploadImage);
  }

  Future<void> _onInit(AddTxInitEvent event, Emitter<AddTxState> emit) async {
    emit(AddTxLoading());
    final catsRaw = await getCategories(isIncome: false);
    final cats = List<CategoryEntity>.from(catsRaw);
    final sources = await getMoneySources();
    // Copy to force an actual List<MoneySourceEntity> instead of a List<MoneySourceModel>
    final normalizedSources = List<MoneySourceEntity>.from(sources);

    emit(
      AddTxLoaded(
        tab: EntryTab.manual,
        type: TransactionType.expense,
        categories: cats,
        moneySources: normalizedSources,
        selectedCategory: cats.isNotEmpty ? cats.first : null,
        moneySource: normalizedSources.isNotEmpty
            ? normalizedSources.first.name
            : '',
        amount: '',
        merchant: '',
        date: '',
        isEdit: false,
        originalTx: null,
      ),
    );
  }

  Future<void> _onInitEdit(
    AddTxInitEditEvent event,
    Emitter<AddTxState> emit,
  ) async {
    emit(AddTxLoading());
    final catsRaw = await getCategories(isIncome: event.transaction.isIncome);
    final cats = List<CategoryEntity>.from(catsRaw);
    final sources = await getMoneySources();
    final normalizedSources = List<MoneySourceEntity>.from(sources);

    final selectedCat = cats.firstWhere(
      (c) => c.id == event.transaction.category.id,
      orElse: () => cats.isNotEmpty ? cats.first : event.transaction.category,
    );

    final selectedMoneySource = normalizedSources.firstWhere(
      (m) => m.id == event.transaction.moneySource.id,
      orElse: () => normalizedSources.isNotEmpty
          ? normalizedSources.first
          : event.transaction.moneySource,
    );

    String _two(int n) => n.toString().padLeft(2, '0');
    final dt = event.transaction.dateTime;
    final dateStr =
        "${dt.year}-${_two(dt.month)}-${_two(dt.day)} ${_two(dt.hour)}:${_two(dt.minute)}";

    emit(
      AddTxLoaded(
        tab: EntryTab.manual,
        type: event.transaction.isIncome
            ? TransactionType.income
            : TransactionType.expense,
        categories: cats,
        moneySources: normalizedSources,
        selectedCategory: selectedCat,
        moneySource: selectedMoneySource.name,
        amount: event.transaction.amount.toString(),
        merchant: event.transaction.merchant,
        date: dateStr,
        isEdit: true,
        originalTx: event.transaction,
      ),
    );
  }

  void _onTabChanged(AddTxTabChangedEvent event, Emitter<AddTxState> emit) {
    final s = state;
    if (s is AddTxLoaded) {
      emit(s.copyWith(tab: event.tab));
    }
  }

  Future<void> _onTypeChanged(
    AddTxTypeChangedEvent event,
    Emitter<AddTxState> emit,
  ) async {
    final s = state;
    if (s is AddTxLoaded) {
      emit(AddTxLoading());
      final cats = await getCategories(
        isIncome: event.type == TransactionType.income,
      );

      emit(
        s.copyWith(
          type: event.type,
          categories: cats,
          selectedCategory: cats.isNotEmpty
              ? cats.first
              : null, // reset category for new list
          updateCategory: true,
          amountError: null,
          categoryError: null,
          dateError: null,
          moneySourceError: null,
        ),
      );
    }
  }

  void _onCategory(AddTxCategorySelectedEvent e, Emitter<AddTxState> emit) {
    final s = state;
    if (s is AddTxLoaded) {
      emit(
        s.copyWith(
          selectedCategory: e.category,
          updateCategory: true,
          categoryError: null,
        ),
      );
    }
  }

  void _onMoneySource(
    AddTxMoneySourceChangedEvent e,
    Emitter<AddTxState> emit,
  ) {
    final s = state;
    if (s is AddTxLoaded) {
      emit(s.copyWith(moneySource: e.moneySource, moneySourceError: null));
    }
  }

  void _onDate(AddTxDateChangedEvent e, Emitter<AddTxState> emit) {
    final s = state;
    if (s is AddTxLoaded) {
      emit(s.copyWith(date: e.date, dateError: null));
    }
  }

  void _onAmount(AddTxAmountChangedEvent event, Emitter<AddTxState> emit) {
    final s = state;
    if (s is AddTxLoaded) {
      emit(s.copyWith(amount: event.amount, amountError: null));
    }
  }

  void _onMerchant(AddTxMerchantChangedEvent event, Emitter<AddTxState> emit) {
    final s = state;
    if (s is AddTxLoaded) {
      emit(s.copyWith(merchant: event.merchant, merchantError: null));
    }
  }

  Future<void> _onSubmit(
    AddTxSubmitEvent event,
    Emitter<AddTxState> emit,
  ) async {
    final s = state;
    if (s is! AddTxLoaded) return;

    try {
      // Validate required fields first; don't proceed if invalid.
      final String? amountError = (() {
        if (s.amount.trim().isEmpty) return 'Amount is required';
        final value = double.tryParse(s.amount);
        if (value == null || value <= 0) return 'Enter a valid amount';
        return null;
      })();

      final String? categoryError = s.selectedCategory == null
          ? 'Please select category'
          : null;

      final String? dateError = (s.date.isEmpty) ? 'Please pick a date' : null;
      final String? merchantError = s.merchant.trim().isEmpty
          ? 'Merchant is required'
          : null;

      final String? moneySourceError = (() {
        if (s.moneySource == null || s.moneySource!.isEmpty) {
          return 'Please select money source';
        }
        if (s.moneySources.isEmpty) return 'No money source available';
        return null;
      })();

      final hasError = [
        amountError,
        categoryError,
        dateError,
        merchantError,
        moneySourceError,
      ].any((e) => e != null);

      if (hasError) {
        emit(
          s.copyWith(
            amountError: amountError,
            categoryError: categoryError,
            dateError: dateError,
            merchantError: merchantError,
            moneySourceError: moneySourceError,
          ),
        );
        return;
      }

      emit(AddTxLoading());

      final CategoryEntity category = s.selectedCategory!;

      final MoneySourceEntity ms = s.moneySources.firstWhere(
        (m) => m.name == s.moneySource,
        orElse: () => s.moneySources.first,
      );

      final amount = double.tryParse(s.amount)!;

      final DateTime dateTime = DateTime.parse(s.date);

      final isIncome = s.type == TransactionType.income;

      final tx = TransactionEntity(
        amount: amount,
        dateTime: dateTime,
        merchant: s.merchant,
        category: category,
        moneySource: ms,
        isIncome: isIncome,
      );

      // 1) Lưu transaction
      if (s.isEdit) {
        final oldTx = s.originalTx;
        if (oldTx == null || oldTx.id == null || oldTx.id!.isEmpty) {
          throw Exception('Original transaction missing');
        }

        final updatedTx = TransactionEntity(
          id: oldTx.id,
          amount: amount,
          dateTime: dateTime,
          merchant: s.merchant,
          category: category,
          moneySource: ms,
          isIncome: isIncome,
        );

        await updateTx(oldTx: oldTx, newTx: updatedTx);

        emit(
          AddTxSubmitSuccess(
            transaction: updatedTx,
            tab: s.tab,
            type: s.type,
            categories: s.categories,
            moneySources: s.moneySources,
            selectedCategory: category,
            amount: s.amount,
            date: s.date,
            moneySource: s.moneySource,
            merchant: s.merchant,
            isEdit: true,
            originalTx: updatedTx,
          ),
        );
        return;
      } else {
        final newId = await saveTx(tx);
        final savedTx = TransactionEntity(
          id: newId,
          amount: amount,
          dateTime: dateTime,
          merchant: s.merchant,
          category: category,
          moneySource: ms,
          isIncome: isIncome,
        );

        // 2) Cập nhật balance cho money source
        await changeBalance(
          moneySourceId: ms.id,
          amount: amount,
          isIncome: isIncome,
        );

        emit(
          AddTxSubmitSuccess(
            transaction: savedTx,
            tab: s.tab,
            type: s.type,
            categories: s.categories,
            moneySources: s.moneySources,
            selectedCategory: category,
            amount: s.amount,
            date: s.date,
            moneySource: s.moneySource,
            merchant: s.merchant,
            isEdit: false,
            originalTx: savedTx,
          ),
        );
      }
    } catch (e, st) {
      print('AddTxBloc _onSubmit error: $e');
      print(st);
      emit(AddTxError(e.toString()));
    }
  }

  Future<void> _onUploadImage(
    UploadImageEvent event,
    Emitter<AddTxState> emit,
  ) async {
    final previousState = state;
    if (previousState is! AddTxLoaded) return;

    emit(ImageUploadInProgress(previousState));
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(
          ImageUploadFailure(
            statusCode: -1,
            data: 'User not logged in',
            base: previousState,
          ),
        );
        return;
      }

      final UploadImageResult result = await uploadImage(
        image: event.image,
        userId: uid,
        moneySources: previousState.moneySources,
      );
      if (result.statusCode == 200) {
        emit(
          ImageUploadSuccess(
            statusCode: result.statusCode,
            data: result.data,
            base: previousState,
          ),
        );
      } else {
        emit(
          ImageUploadFailure(
            statusCode: result.statusCode,
            data: result.data,
            base: previousState,
          ),
        );
      }
    } catch (e) {
      emit(
        ImageUploadFailure(
          statusCode: -1,
          data: e.toString(),
          base: previousState,
        ),
      );
    } finally {
      emit(previousState);
    }
  }
}
