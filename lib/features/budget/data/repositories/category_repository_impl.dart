import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remote;

  CategoryRepositoryImpl(this.remote);

  @override
  Future<List<CategoryEntity>> getCategories(bool isIncome) async {
    final data = await remote.getCategories(isIncome);
    return data; // vì CategoryModel extends CategoryEntity
  }
}
