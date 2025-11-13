import '../entities/category_entity.dart';
import '../repositories/add_tx_repository.dart';

class GetCategoriesUsecase {
  final AddTxRepository repo;
  GetCategoriesUsecase(this.repo);

  Future<List<CategoryEntity>> call({required bool isIncome}) {
    return repo.getCategories(isIncome: isIncome);
  }
}
