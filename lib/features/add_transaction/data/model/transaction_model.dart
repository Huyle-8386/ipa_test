import 'package:fintrack/features/add_transaction/data/model/category_model.dart';
import 'package:fintrack/features/add_transaction/data/model/money_source_model.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    super.id,
    required super.amount,
    required super.dateTime,
    required super.note,
    required CategoryModel super.category,
    required MoneySourceModel super.moneySource,
    required super.isIncome,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'dateTime': dateTime.toIso8601String(),
    'note': note,
    'category': (category as CategoryModel).toJson(),
    'moneySource': (moneySource as MoneySourceModel).toJson(),
    'isIncome': isIncome,
  };
}
