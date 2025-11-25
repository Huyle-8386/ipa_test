import 'package:fintrack/features/income/domain/entities/income_entity.dart';

class IncomeModel extends IncomeEntity {
  const IncomeModel({
    super.id,
    required super.categoryId,
    required super.categoryName,
    super.categoryIcon,
    required super.amount,
    required super.isIncome,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      id: json['id'] as String?,
      categoryId: json['categoryId'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      categoryIcon: json['categoryIcon'] as String?,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      isIncome: json['isIncome'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'categoryIcon': categoryIcon,
    'amount': amount,
    'isIncome': isIncome,
  };
}
