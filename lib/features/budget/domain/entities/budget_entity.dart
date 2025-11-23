// // lib/features/budget/domain/entities/budget_entity.dart
// import 'package:flutter/material.dart';

// class BudgetExpenseEntity {
//   final String category;
//   final double amount;
//   final int colorValue;

//   const BudgetExpenseEntity({
//     required this.category,
//     required this.amount,
//     required this.colorValue,
//   });
// }

// class BudgetEntity {
//   final String name;
//   final double spent;
//   final double total;
//   final bool isActive;
//   final List<double> monthlySpending;
//   final List<double> monthlyBudgetLimit;
//   final List<BudgetExpenseEntity> expenses;

//   const BudgetEntity({
//     required this.name,
//     required this.spent,
//     required this.total,
//     required this.isActive,
//     this.monthlySpending = const [],
//     this.monthlyBudgetLimit = const [],
//     this.expenses = const [],
//   });

//   double get percent => total == 0 ? 0 : (spent / total) * 100;

//   String get status {
//     if (percent < 80) return "Within";
//     if (percent >= 80 && percent < 100) return "Risk";
//     return "Overspending";
//   }
// }

class BudgetEntity {
  final String id;
  final String name;
  final double amount;
  final double spent;
  final String categoryId;
  final String sourceId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  const BudgetEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.spent,
    required this.categoryId,
    required this.sourceId,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  BudgetEntity copyWith({
    String? id,
    String? name,
    double? amount,
    double? spent,
    String? categoryId,
    String? sourceId,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) {
    return BudgetEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      spent: spent ?? this.spent,
      categoryId: categoryId ?? this.categoryId,
      sourceId: sourceId ?? this.sourceId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
    );
  }

  double get percent => amount == 0 ? 0 : (spent / amount) * 100;

  String get status {
    final p = percent;
    if (p < 80) return "Within";
    if (p >= 80 && p < 100) return "Risk";
    return "Overspending";
  }
}
