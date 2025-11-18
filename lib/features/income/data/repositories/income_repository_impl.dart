import 'package:fintrack/features/income/data/datasources/income_data.dart';
import 'package:fintrack/features/income/domain/entities/income_entity.dart';
import 'package:fintrack/features/income/domain/repositories/income_repository.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final IncomeLocalDataSource localDataSource;

  IncomeRepositoryImpl(this.localDataSource);

  @override
  Future<List<IncomeEntity>> getIncome({required String category}) {
    return localDataSource.getIncome(category: category);
  }

  @override
  Future<List<String>> getCategories() {
    return localDataSource.getCategories();
  }

  @override
  Future<List<IncomeEntity>> searchIncome({required String query}) {
    return localDataSource.searchIncome(query: query);
  }
}
