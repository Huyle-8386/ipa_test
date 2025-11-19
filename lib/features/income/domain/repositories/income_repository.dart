import 'package:fintrack/features/income/domain/entities/income_entity.dart';

abstract class IncomeRepository {
  Future<List<IncomeEntity>> getIncome({required String category});
  Future<List<String>> getCategories();
  Future<List<IncomeEntity>> searchIncome({required String query});
}
