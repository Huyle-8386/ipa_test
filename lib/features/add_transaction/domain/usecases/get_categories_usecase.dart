import 'package:fintrack/features/add_transaction/domain/repositories/category_repository.dart';

import '../entities/category_entity.dart';
import '../repositories/add_tx_repository.dart';

class GetCategoriesUsecase {
  final CategoryRepository repo;

  GetCategoriesUsecase(this.repo);

  Future<List<CategoryEntity>> call({required bool isIncome}) async {
    return repo.getCategories(isIncome);
  }
}
