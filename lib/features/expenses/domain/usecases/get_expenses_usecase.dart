import 'package:fintrack/features/expenses/domain/entities/expense_entity.dart';
import 'package:fintrack/features/expenses/domain/repositories/expenses_repository.dart';

class GetExpensesUsecase {
  final ExpensesRepository repository;

  GetExpensesUsecase(this.repository);

  Future<List<ExpenseEntity>> call({required String category}) {
    return repository.getExpenses(category: category);
  }
}
