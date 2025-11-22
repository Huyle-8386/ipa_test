import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_categories.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategories getCategories;

  CategoryBloc(this.getCategories) : super(CategoryState.initial()) {
    on<LoadCategories>(_onLoad);
  }

  Future<void> _onLoad(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final items = await getCategories(event.isIncome);

    emit(state.copyWith(loading: false, categories: items));
  }
}
