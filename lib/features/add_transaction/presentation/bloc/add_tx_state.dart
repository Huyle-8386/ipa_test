import 'package:fintrack/features/add_transaction/domain/entities/category_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';

enum EntryTab { manual, image }

enum TransactionType { expense, income }

abstract class AddTxState {}

class AddTxInitial extends AddTxState {}

class AddTxLoading extends AddTxState {}

class AddTxLoaded extends AddTxState {
  static const Object _unset = Object();

  final EntryTab tab;
  final TransactionType type;
  final List<CategoryEntity> categories;
  final List<MoneySourceEntity> moneySources;
  final CategoryEntity? selectedCategory;
  final String amount;
  final String date;
  final String? moneySource;
  final String merchant;
  final bool isEdit;
  final TransactionEntity? originalTx;
  final String? amountError;
  final String? categoryError;
  final String? dateError;
  final String? moneySourceError;
  final String? merchantError;

  AddTxLoaded({
    required this.tab,
    required this.type,
    required this.categories,
    required this.moneySources,
    this.selectedCategory,
    this.amount = '',
    this.date = '',
    this.moneySource = '',
    this.merchant = '',
    this.isEdit = false,
    this.originalTx,
    this.amountError,
    this.categoryError,
    this.dateError,
    this.moneySourceError,
    this.merchantError,
  });

  AddTxLoaded copyWith({
    EntryTab? tab,
    TransactionType? type,
    List<CategoryEntity>? categories,
    List<MoneySourceEntity>? moneySources,
    CategoryEntity? selectedCategory,
    String? amount,
    String? date,
    String? moneySource,
    String? merchant,
    bool updateCategory = false,
    bool? isEdit,
    TransactionEntity? originalTx,
    Object? amountError = _unset,
    Object? categoryError = _unset,
    Object? dateError = _unset,
    Object? moneySourceError = _unset,
    Object? merchantError = _unset,
  }) => AddTxLoaded(
    tab: tab ?? this.tab,
    type: type ?? this.type,
    categories: categories ?? this.categories,
    moneySources: moneySources ?? this.moneySources,
    // Keep selectedCategory unless explicitly updating it.
    selectedCategory: updateCategory ? selectedCategory : this.selectedCategory,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    moneySource: moneySource ?? this.moneySource,
    merchant: merchant ?? this.merchant,
    isEdit: isEdit ?? this.isEdit,
    originalTx: originalTx ?? this.originalTx,
    amountError: amountError == _unset
        ? this.amountError
        : amountError as String?,
    categoryError: categoryError == _unset
        ? this.categoryError
        : categoryError as String?,
    dateError: dateError == _unset ? this.dateError : dateError as String?,
    moneySourceError: moneySourceError == _unset
        ? this.moneySourceError
        : moneySourceError as String?,
    merchantError: merchantError == _unset
        ? this.merchantError
        : merchantError as String?,
  );
}

class AddTxSubmitting extends AddTxState {}

class AddTxSubmitSuccess extends AddTxLoaded {
  final TransactionEntity transaction;
  AddTxSubmitSuccess({
    required this.transaction,
    required super.tab,
    required super.type,
    required super.categories,
    required super.moneySources,
    super.selectedCategory,
    super.amount,
    super.date,
    super.moneySource,
    super.merchant,
    super.isEdit,
    super.originalTx,
  });
}

class AddTxError extends AddTxState {
  final String error;
  AddTxError(this.error);
}

class ImageUploadInProgress extends AddTxState {
  final AddTxLoaded base;
  ImageUploadInProgress(this.base);
}

class ImageUploadSuccess extends AddTxState {
  final int statusCode;
  final dynamic data;
  final AddTxLoaded base;
  ImageUploadSuccess({
    required this.statusCode,
    required this.data,
    required this.base,
  });
}

class ImageUploadFailure extends AddTxState {
  final int statusCode;
  final dynamic data;
  final AddTxLoaded base;
  ImageUploadFailure({
    required this.statusCode,
    required this.data,
    required this.base,
  });
}
