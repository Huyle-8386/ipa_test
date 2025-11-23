import 'package:fintrack/features/expenses/data/models/expense_model.dart';

/// Abstract data source interface for expenses feature.
/// Implementations can be local (mock) or remote (Firestore).
abstract class ExpensesDataSource {
  Future<List<ExpenseModel>> getExpenses({required String category});
  Future<List<ExpenseModel>> getPreviousExpenses({required String category});
  Future<List<String>> getCategories();
  Future<List<ExpenseModel>> searchExpenses({required String query});
}

// Keep a typedef-compatible name used elsewhere
typedef ExpensesLocalDataSource = ExpensesDataSource;
