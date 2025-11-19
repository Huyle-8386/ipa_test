import 'package:fintrack/features/expenses/domain/entities/expense_entity.dart';
import 'package:fintrack/features/expenses/domain/repositories/expenses_repository.dart';

class SearchExpensesUsecase {
  final ExpensesRepository repository;

  SearchExpensesUsecase(this.repository);

  Future<List<ExpenseEntity>> call({required String query}) {
    return repository.searchExpenses(query: query);
  }
}
