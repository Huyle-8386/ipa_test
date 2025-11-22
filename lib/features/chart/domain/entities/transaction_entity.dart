class TransactionEntity {
  final String id;
  final double amount;
  final String categoryId;
  final String categoryName;
  final String moneySourceId;
  final String moneySourceName;
  final String note;
  final DateTime dateTime;
  final bool isIncome;

  TransactionEntity({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.categoryName,
    required this.moneySourceId,
    required this.moneySourceName,
    required this.note,
    required this.dateTime,
    required this.isIncome,
  });
}
