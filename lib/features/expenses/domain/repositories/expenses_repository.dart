import 'package:fintrack/features/expenses/domain/entities/expense_entity.dart';

abstract class ExpensesRepository {
  Future<List<ExpenseEntity>> getExpenses({required String category});
  Future<List<ExpenseEntity>> getPreviousExpenses({required String category});
  Future<List<String>> getCategories();
  Future<List<ExpenseEntity>> searchExpenses({required String query});
}
