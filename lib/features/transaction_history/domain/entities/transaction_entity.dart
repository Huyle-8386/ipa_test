import 'package:fintrack/core/utils/currency_formatter.dart';

enum TransactionType { spending, income, all }

class TransactionEntity {
  final String? id;
  final String categoryId;
  final String categoryName;
  final String? categoryIcon; // Icon path from category
  final String moneySourceName;
  final String merchant;
  final double amount;
  final DateTime dateTime;
  final bool isIncome;

  const TransactionEntity({
    this.id,
    required this.categoryId,
    required this.categoryName,
    this.categoryIcon,
    required this.moneySourceName,
    required this.merchant,
    required this.amount,
    required this.dateTime,
    required this.isIncome,
  });

  // Helper getters
  TransactionType get type =>
      isIncome ? TransactionType.income : TransactionType.spending;

  String get formattedAmount => isIncome
      ? '+${CurrencyFormatter.formatVNDWithSymbol(amount)}'
      : '-${CurrencyFormatter.formatVNDWithSymbol(amount)}';

  String get formattedTime {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'pm' : 'am';
    return '$hour:$minute $period';
  }
}
