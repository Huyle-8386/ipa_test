import '../../../transaction_history/domain/entities/transaction_entity.dart';

/// IncomeEntity summarizes income per category similar to ExpenseEntity.
class IncomeEntity {
  final String? id;
  final String categoryId;
  final String categoryName;
  final String? categoryIcon;
  final double amount;
  final bool isIncome;

  const IncomeEntity({
    this.id,
    required this.categoryId,
    required this.categoryName,
    this.categoryIcon,
    required this.amount,
    required this.isIncome,
  });

  String get formattedAmount =>
      isIncome ? amount.toStringAsFixed(2) : amount.toStringAsFixed(2);

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
