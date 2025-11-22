enum TransactionType { spending, income, all }

class TransactionEntity {
  final String? id;
  final String categoryId;
  final String categoryName;
  final String? categoryIcon; // Icon path from category
  final String moneySourceName;
  final String note;
  final double amount;
  final DateTime dateTime;
  final bool isIncome;

  const TransactionEntity({
    this.id,
    required this.categoryId,
    required this.categoryName,
    this.categoryIcon,
    required this.moneySourceName,
    required this.note,
    required this.amount,
    required this.dateTime,
    required this.isIncome,
  });

  // Helper getters
  TransactionType get type =>
      isIncome ? TransactionType.income : TransactionType.spending;

  String get formattedAmount => isIncome
      ? '+\$${amount.toStringAsFixed(2)}'
      : '-\$${amount.toStringAsFixed(2)}';

  String get formattedTime {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'pm' : 'am';
    return '$hour:$minute $period';
  }
}
