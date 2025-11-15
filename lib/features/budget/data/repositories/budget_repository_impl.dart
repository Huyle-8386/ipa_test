// lib/features/budget/data/repositories_impl/budget_repository_impl.dart
import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_datasource.dart';
import '../models/budget_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  @override
  Future<List<BudgetEntity>> getAllBudgets() async {
    // Simulate latency if needed; here return directly
    final List<BudgetModel> raw = BudgetDataSource.budgets;
    return raw.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> refresh() async {
    // For in-memory datasource there's nothing to refresh.
    return;
  }
}
