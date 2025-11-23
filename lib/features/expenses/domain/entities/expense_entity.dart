import 'package:fintrack/features/transaction_%20history/domain/entities/transaction_entity.dart';

/// ExpenseEntity now mirrors a summarized category item.
/// Fields:
/// - categoryId, categoryName, optional categoryIcon (mapped from categories)
/// - amount: total amount (double)
/// - isIncome: whether this item represents income (usually false for expenses)
class ExpenseEntity {
  final String? id;
  final String categoryId;
  final String categoryName;
  final String? categoryIcon;
  final double amount;
  final bool isIncome;

  const ExpenseEntity({
    this.id,
    required this.categoryId,
    required this.categoryName,
    this.categoryIcon,
    required this.amount,
    required this.isIncome,
  });

  String get formattedAmount => isIncome
      ? ' ${amount.toStringAsFixed(2)}'
      : ' ${amount.toStringAsFixed(2)}';

  /// Reuse helpers from TransactionEntity where appropriate
  String get formattedTime => TransactionEntity(
    categoryId: categoryId,
    categoryName: categoryName,
    moneySourceName: '',
    note: '',
    amount: amount,
    dateTime: DateTime.now(),
    isIncome: isIncome,
  ).formattedTime;
}
