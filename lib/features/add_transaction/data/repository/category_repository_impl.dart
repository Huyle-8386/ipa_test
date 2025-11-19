import 'package:fintrack/features/add_transaction/data/datasource/%20category_remote_datasource.dart';
import 'package:fintrack/features/add_transaction/domain/entities/category_entity.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remote;

  CategoryRepositoryImpl(this.remote);

  @override
  Future<List<CategoryEntity>> getCategories(bool isIncome) {
    return remote.getCategories(isIncome);
  }
}
