class BudgetModel {
  final String name;
  final double spent;
  final double total;
  final bool isActive;

  final List<double> monthlySpending;

  final List<double> monthlyBudgetLimit;

  final List<BudgetExpense> expenses;

  BudgetModel({
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

class BudgetExpense {
  final String category;
  final double amount;
  final int colorValue;

  const BudgetExpense({
    required this.category,
    required this.amount,
    required this.colorValue,
  });
}
