import 'package:fintrack/features/income/domain/repositories/income_repository.dart';

class GetIncomeCategoriesUsecase {
  final IncomeRepository repository;
  GetIncomeCategoriesUsecase(this.repository);

  Future<List<String>> call() {
    return repository.getCategories();
  }
}
