import 'package:fintrack/features/expenses/domain/repositories/expenses_repository.dart';

class GetCategoriesUsecase {
  final ExpensesRepository repository;

  GetCategoriesUsecase(this.repository);

  Future<List<String>> call() {
    return repository.getCategories();
  }
}
