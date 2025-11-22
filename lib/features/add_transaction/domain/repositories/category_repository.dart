import 'package:fintrack/features/add_transaction/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategories(bool isIncome);
}
