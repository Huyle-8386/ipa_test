import '../repositories/budget_repository.dart';

class DeleteBudget {
  final BudgetRepository repository;
  DeleteBudget(this.repository);

  Future<void> call(String budgetId, String uid) async {
    return repository.deleteBudget(budgetId, uid);
  }
}
