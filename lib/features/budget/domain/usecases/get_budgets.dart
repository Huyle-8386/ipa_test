// // lib/features/budget/domain/usecases/get_budgets.dart
// import '../entities/budget_entity.dart';
// import '../repositories/budget_repository.dart';

// class GetBudgets {
//   final BudgetRepository repository;
//   GetBudgets(this.repository);

//   Future<List<BudgetEntity>> call() async {
//     return await repository.getAllBudgets();
//   }
// }

import '../entities/budget_entity.dart';
import '../repositories/budget_repository.dart';

class GetBudgets {
  final BudgetRepository repository;
  GetBudgets(this.repository);

  Future<List<BudgetEntity>> call(String uid) async {
    return repository.getBudgets(uid);
  }
}
