import 'package:fintrack/features/add_transaction/domain/entities/category_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';

class TransactionEntity {
  final String? id;
  final double amount;
  final DateTime dateTime;
  final String note;
  final CategoryEntity category;
  final MoneySourceEntity moneySource;
  final bool isIncome;

  const TransactionEntity({
    this.id,
    required this.amount,
    required this.dateTime,
    required this.note,
    required this.category,
    required this.moneySource,
    required this.isIncome,
  });
}

