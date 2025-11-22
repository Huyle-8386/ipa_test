import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {
  final bool isIncome;
  const LoadCategories(this.isIncome);

  @override
  List<Object?> get props => [isIncome];
}
