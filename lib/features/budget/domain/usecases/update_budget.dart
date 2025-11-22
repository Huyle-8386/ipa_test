import '../entities/budget_entity.dart';
import '../repositories/budget_repository.dart';

class UpdateBudget {
  final BudgetRepository repository;
  UpdateBudget(this.repository);

  Future<void> call(BudgetEntity budget, String uid) async {
    return repository.updateBudget(budget, uid);
  }
}
