import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/features/transaction_history/domain/entities/transaction_entity.dart';

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
      ? CurrencyFormatter.formatVNDWithSymbol(amount)
      : CurrencyFormatter.formatVNDWithSymbol(amount);

  /// Reuse helpers from TransactionEntity where appropriate
  String get formattedTime => TransactionEntity(
    categoryId: categoryId,
    categoryName: categoryName,
    moneySourceName: '',
    merchant: '',
    amount: amount,
    dateTime: DateTime.now(),
    isIncome: isIncome,
  ).formattedTime;
}
