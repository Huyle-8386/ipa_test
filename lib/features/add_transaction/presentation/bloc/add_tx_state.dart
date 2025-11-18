import 'package:fintrack/features/add_transaction/domain/entities/category_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';

enum EntryTab { manual, image }

enum TransactionType { expense, income }

abstract class AddTxState {}

class AddTxInitial extends AddTxState {}

class AddTxLoading extends AddTxState {}

class AddTxLoaded extends AddTxState {
  final EntryTab tab;
  final TransactionType type;
  final List<CategoryEntity> categories;
  final List<MoneySourceEntity> moneySources;
  final int? selectedCategoryIndex;
  final String amount;
  final String date;
  final String? moneySource;
  final String note;

  AddTxLoaded({
    required this.tab,
    required this.type,
    required this.categories,
    required this.moneySources,

    this.selectedCategoryIndex,
    this.amount = '',
    this.date = '',
    this.moneySource = '',
    this.note = '',
  });

  AddTxLoaded copyWith({
    EntryTab? tab,
    TransactionType? type,
    List<CategoryEntity>? categories,
    List<MoneySourceEntity>? moneySources,
    int? selectedCategoryIndex,
    String? amount,
    String? date,
    String? moneySource,
    String? note,
  }) => AddTxLoaded(
    tab: tab ?? this.tab,
    type: type ?? this.type,
    categories: categories ?? this.categories,
    moneySources: moneySources ?? this.moneySources,
    selectedCategoryIndex: selectedCategoryIndex,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    moneySource: moneySource ?? this.moneySource,
    note: note ?? this.note,
  );
}

class AddTxSubmitting extends AddTxState {}

class AddTxSubmitSuccess extends AddTxState {}

class AddTxError extends AddTxState {
  final String error;
  AddTxError(this.error);
}
