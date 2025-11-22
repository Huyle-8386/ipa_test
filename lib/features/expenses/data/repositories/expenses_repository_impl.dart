import 'package:fintrack/features/expenses/data/datasources/expenses_data.dart';
import 'package:fintrack/features/expenses/domain/entities/expense_entity.dart';
import 'package:fintrack/features/expenses/domain/repositories/expenses_repository.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  final ExpensesLocalDataSource localDataSource;

  ExpensesRepositoryImpl(this.localDataSource);

  @override
  Future<List<ExpenseEntity>> getExpenses({required String category}) {
    return localDataSource.getExpenses(category: category);
  }

  @override
  Future<List<String>> getCategories() {
    return localDataSource.getCategories();
  }

  @override
  Future<List<ExpenseEntity>> searchExpenses({required String query}) {
    return localDataSource.searchExpenses(query: query);
  }
}
