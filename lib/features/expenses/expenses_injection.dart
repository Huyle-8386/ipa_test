import 'package:fintrack/features/expenses/data/datasources/expenses_data.dart';
import 'package:fintrack/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:fintrack/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:fintrack/features/expenses/domain/usecases/get_categories_usecase.dart';
import 'package:fintrack/features/expenses/domain/usecases/get_expenses_usecase.dart';
import 'package:fintrack/features/expenses/domain/usecases/search_expenses_usecase.dart';
import 'package:fintrack/features/expenses/presentation/bloc/expenses_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initExpenses() async {
  // Data sources
  sl.registerLazySingleton<ExpensesLocalDataSource>(
    () => ExpensesLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<ExpensesRepository>(
    () => ExpensesRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetExpensesUsecase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => SearchExpensesUsecase(sl()));

  // Bloc
  sl.registerFactory(
    () => ExpensesBloc(
      getExpenses: sl(),
      getCategories: sl(),
      searchExpenses: sl(),
    ),
  );
}
