import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/features/expenses/data/models/expense_model.dart';
import 'package:flutter/material.dart';

abstract class ExpensesLocalDataSource {
  Future<List<ExpenseModel>> getExpenses({required String category});
  Future<List<String>> getCategories();
  Future<List<ExpenseModel>> searchExpenses({required String query});
}

class ExpensesLocalDataSourceImpl implements ExpensesLocalDataSource {
  static const List<ExpenseModel> _allExpenses = [
    ExpenseModel(
      icon: 'assets/images/groeries.png',
      color: Colors.green,
      name: "Groceries",
      value: 167.30,
      amount: "\$167.30",
      percentage: "18%",
      isUp: true,
    ),
    ExpenseModel(
      icon: 'assets/images/shopping.png',
      color: Colors.orange,
      name: "Shopping",
      value: 245.50,
      amount: "\$245.50",
      percentage: "26%",
      isUp: false,
    ),
    ExpenseModel(
      icon: 'assets/images/food.png',
      color: AppColors.orange,
      name: "Food",
      value: 89.20,
      amount: "\$89.20",
      percentage: "9%",
      isUp: true,
    ),
    ExpenseModel(
      icon: 'assets/images/health.png',
      color: Colors.cyan,
      name: "Health",
      value: 55.00,
      amount: "\$55.00",
      percentage: "6%",
      isUp: false,
    ),
    ExpenseModel(
      icon: 'assets/images/travel.png',
      color: Colors.purple,
      name: "Travel",
      value: 310.00,
      amount: "\$310.00",
      percentage: "33%",
      isUp: true,
    ),
    ExpenseModel(
      icon: 'assets/images/taxi.png',
      color: AppColors.blue,
      name: "Taxi",
      value: 76.97,
      amount: "\$76.97",
      percentage: "8%",
      isUp: false,
    ),
  ];

  static const List<String> _categories = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  @override
  Future<List<ExpenseModel>> getExpenses({required String category}) async {
    // Giả lập delay như call API/DB
    await Future.delayed(const Duration(milliseconds: 100));

    // Filter theo category
    switch (category) {
      case 'Daily':
        return _allExpenses.take(3).toList();
      case 'Weekly':
        return _allExpenses.take(4).toList();
      case 'Monthly':
        return _allExpenses.take(5).toList();
      case 'Yearly':
        return _allExpenses;
      default:
        return _allExpenses;
    }
  }

  @override
  Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _categories;
  }

  @override
  Future<List<ExpenseModel>> searchExpenses({required String query}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (query.isEmpty) {
      return _allExpenses;
    }

    return _allExpenses
        .where(
          (expense) => expense.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
