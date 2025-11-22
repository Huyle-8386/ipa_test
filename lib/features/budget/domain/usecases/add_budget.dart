import '../entities/budget_entity.dart';
import '../repositories/budget_repository.dart';

class AddBudget {
  final BudgetRepository repository;
  AddBudget(this.repository);

  Future<void> call(BudgetEntity budget, String uid) async {
    return repository.addBudget(budget, uid);
  }
}
