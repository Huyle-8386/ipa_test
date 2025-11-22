import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository repository;

  GetCategories(this.repository);

  Future<List<CategoryEntity>> call(bool isIncome) async {
    return await repository.getCategories(isIncome);
  }
}
