// lib/features/budget/data/models/budget_model.dart
import 'package:flutter/material.dart';
import '../../domain/entities/budget_entity.dart';

class BudgetModel {
  final String name;
  final double spent;
  final double total;
  final bool isActive;
  final List<double> monthlySpending;
  final List<double> monthlyBudgetLimit;
  final List<BudgetExpenseModel> expenses;

  BudgetModel({
    required this.name,
    required this.spent,
    required this.total,
    required this.isActive,
    this.monthlySpending = const [],
    this.monthlyBudgetLimit = const [],
    this.expenses = const [],
  });

  factory BudgetModel.fromEntity(BudgetEntity e) {
    return BudgetModel(
      name: e.name,
      spent: e.spent,
      total: e.total,
      isActive: e.isActive,
      monthlySpending: e.monthlySpending,
      monthlyBudgetLimit: e.monthlyBudgetLimit,
      expenses: e.expenses
          .map(
            (ex) => BudgetExpenseModel(
              category: ex.category,
              amount: ex.amount,
              colorValue: ex.colorValue,
            ),
          )
          .toList(),
    );
  }

  BudgetEntity toEntity() {
    return BudgetEntity(
      name: name,
      spent: spent,
      total: total,
      isActive: isActive,
      monthlySpending: monthlySpending,
      monthlyBudgetLimit: monthlyBudgetLimit,
      expenses: expenses
          .map(
            (e) => BudgetExpenseEntity(
              category: e.category,
              amount: e.amount,
              colorValue: e.colorValue,
            ),
          )
          .toList(),
    );
  }
}

class BudgetExpenseModel {
  final String category;
  final double amount;
  final int colorValue;

  BudgetExpenseModel({
    required this.category,
    required this.amount,
    required this.colorValue,
  });
}
