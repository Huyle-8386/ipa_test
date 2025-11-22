import 'package:fintrack/features/income/domain/entities/income_entity.dart';
import 'package:fintrack/features/income/domain/repositories/income_repository.dart';

class SearchIncomeUsecase {
  final IncomeRepository repository;
  SearchIncomeUsecase(this.repository);

  Future<List<IncomeEntity>> call({required String query}) {
    return repository.searchIncome(query: query);
  }
}
