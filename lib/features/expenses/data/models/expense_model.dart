import 'package:fintrack/features/expenses/domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    super.id,
    required super.categoryId,
    required super.categoryName,
    super.categoryIcon,
    required super.amount,
    required super.isIncome,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String?,
      categoryId: json['categoryId'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      categoryIcon: json['categoryIcon'] as String?,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      isIncome: json['isIncome'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryIcon': categoryIcon,
      'amount': amount,
      'isIncome': isIncome,
    };
  }
}
