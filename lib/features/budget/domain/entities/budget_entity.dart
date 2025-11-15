// lib/features/budget/domain/entities/budget_entity.dart
import 'package:flutter/material.dart';

class BudgetExpenseEntity {
  final String category;
  final double amount;
  final int colorValue;

  const BudgetExpenseEntity({
    required this.category,
    required this.amount,
    required this.colorValue,
  });
}

class BudgetEntity {
  final String name;
  final double spent;
  final double total;
  final bool isActive;
  final List<double> monthlySpending;
  final List<double> monthlyBudgetLimit;
  final List<BudgetExpenseEntity> expenses;

  const BudgetEntity({
    required this.name,
    required this.spent,
    required this.total,
    required this.isActive,
    this.monthlySpending = const [],
    this.monthlyBudgetLimit = const [],
    this.expenses = const [],
  });

  double get percent => total == 0 ? 0 : (spent / total) * 100;

  String get status {
    if (percent < 80) return "Within";
    if (percent >= 80 && percent < 100) return "Risk";
    return "Overspending";
  }
}
