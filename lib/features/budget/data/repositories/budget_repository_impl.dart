// // lib/features/budget/data/repositories_impl/budget_repository_impl.dart
// import '../../domain/entities/budget_entity.dart';
// import '../../domain/repositories/budget_repository.dart';
// import '../datasources/budget_datasource.dart';
// import '../models/budget_model.dart';

// class BudgetRepositoryImpl implements BudgetRepository {
//   @override
//   Future<List<BudgetEntity>> getAllBudgets() async {
//     // Simulate latency if needed; here return directly
//     final List<BudgetModel> raw = BudgetDataSource.budgets;
//     return raw.map((m) => m.toEntity()).toList();
//   }

//   @override
//   Future<void> refresh() async {
//     // For in-memory datasource there's nothing to refresh.
//     return;
//   }
// }

import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_remote_data_source.dart';
import '../models/budget_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource remote;
  BudgetRepositoryImpl(this.remote);

  @override
  Future<void> addBudget(BudgetEntity budget, String uid) async {
    final model = BudgetModel(
      id: '', // will be auto ID in Firestore
      name: budget.name,
      amount: budget.amount,
      spent: 0, // ensure initial spent = 0
      categoryId: budget.categoryId,
      sourceId: budget.sourceId,
      startDate: budget.startDate,
      endDate: budget.endDate,
      isActive: true,
    );
    await remote.addBudget(uid, model);
  }

  @override
  Future<void> deleteBudget(String budgetId, String uid) async {
    await remote.deleteBudget(uid, budgetId);
  }

  // @override
  // Future<List<BudgetEntity>> getBudgets(String uid) async {
  //   final raw = await remote.getBudgets(uid);
  //   return raw;
  // }

  @override
  Future<List<BudgetEntity>> getBudgets(String uid) async {
    final raw = await remote.getBudgets(uid);
    return raw.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> updateBudget(BudgetEntity budget, String uid) async {
    final model = BudgetModel(
      id: budget.id,
      name: budget.name,
      amount: budget.amount,
      spent: budget.spent,
      categoryId: budget.categoryId,
      sourceId: budget.sourceId,
      startDate: budget.startDate,
      endDate: budget.endDate,
      isActive: true,
    );
    await remote.updateBudget(uid, model);
  }
}
