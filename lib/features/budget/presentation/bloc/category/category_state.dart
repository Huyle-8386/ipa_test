import 'package:equatable/equatable.dart';
import '../../../domain/entities/category_entity.dart';

class CategoryState extends Equatable {
  final bool loading;
  final List<CategoryEntity> categories;

  const CategoryState({required this.loading, required this.categories});

  factory CategoryState.initial() =>
      const CategoryState(loading: false, categories: []);

  CategoryState copyWith({bool? loading, List<CategoryEntity>? categories}) {
    return CategoryState(
      loading: loading ?? this.loading,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [loading, categories];
}
