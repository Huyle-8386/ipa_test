import 'package:fintrack/features/income/data/models/income_model.dart';

/// Abstract data source for Income feature.
/// Implementations can be local mocks or remote Firestore-backed ones.
abstract class IncomeLocalDataSource {
  Future<List<IncomeModel>> getIncome({required String category});
  Future<List<IncomeModel>> getPreviousIncome({required String category});
  Future<List<String>> getCategories();
  Future<List<IncomeModel>> searchIncome({required String query});
}

// NOTE: The previous mock implementation was removed in favor of a remote
// Firestore-backed implementation. If you need a local mock for testing,
// add an implementation of IncomeLocalDataSource here.
