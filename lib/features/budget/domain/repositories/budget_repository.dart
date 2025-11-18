// lib/features/budget/domain/repositories/budget_repository.dart
import '../entities/budget_entity.dart';

abstract class BudgetRepository {
  Future<List<BudgetEntity>> getAllBudgets();
  Future<void> refresh(); // placeholder if needed
}
