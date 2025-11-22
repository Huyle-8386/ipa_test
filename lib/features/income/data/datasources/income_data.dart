import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/features/income/data/models/income_model.dart';

abstract class IncomeLocalDataSource {
  Future<List<IncomeModel>> getIncome({required String category});
  Future<List<String>> getCategories();
  Future<List<IncomeModel>> searchIncome({required String query});
}

class IncomeLocalDataSourceImpl implements IncomeLocalDataSource {
  static const List<IncomeModel> _allIncomes = [
    IncomeModel(
      icon: 'assets/images/groeries.png',
      color: AppColors.green,
      name: "Groceries",
      value: 167.30,
      amount: "\$167.30",
      percentage: "18%",
      isUp: true,
    ),
    IncomeModel(
      icon: 'assets/images/shopping.png',
      color: AppColors.red,
      name: "Shopping",
      value: 245.50,
      amount: "\$245.50",
      percentage: "26%",
      isUp: false,
    ),
    IncomeModel(
      icon: 'assets/images/food.png',
      color: AppColors.orange,
      name: "Food",
      value: 89.20,
      amount: "\$89.20",
      percentage: "9%",
      isUp: true,
    ),
    IncomeModel(
      icon: 'assets/images/health.png',
      color: AppColors.turquoise,
      name: "Health",
      value: 55.00,
      amount: "\$55.00",
      percentage: "6%",
      isUp: false,
    ),
    IncomeModel(
      icon: 'assets/images/travel.png',
      color: AppColors.purple,
      name: "Travel",
      value: 310.00,
      amount: "\$310.00",
      percentage: "33%",
      isUp: true,
    ),
    IncomeModel(
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
  Future<List<IncomeModel>> getIncome({required String category}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    switch (category) {
      case 'Daily':
        return _allIncomes.take(3).toList();
      case 'Weekly':
        return _allIncomes.take(4).toList();
      case 'Monthly':
        return _allIncomes.take(5).toList();
      case 'Yearly':
        return _allIncomes;
      default:
        return _allIncomes;
    }
  }

  @override
  Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _categories;
  }

  @override
  Future<List<IncomeModel>> searchIncome({required String query}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.isEmpty) return _allIncomes;
    return _allIncomes
        .where(
          (income) => income.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
