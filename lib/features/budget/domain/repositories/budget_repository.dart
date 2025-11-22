// // lib/features/budget/domain/repositories/budget_repository.dart
// import '../entities/budget_entity.dart';

// abstract class BudgetRepository {
//   Future<List<BudgetEntity>> getAllBudgets();
//   Future<void> refresh(); // placeholder if needed
// }

import '../../domain/entities/budget_entity.dart';

abstract class BudgetRepository {
  Future<void> addBudget(BudgetEntity budget, String uid);
  Future<List<BudgetEntity>> getBudgets(String uid);
  Future<void> updateBudget(BudgetEntity budget, String uid);
  Future<void> deleteBudget(String budgetId, String uid);
}
