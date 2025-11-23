import 'package:fintrack/features/expenses/data/datasources/expenses_datasource.dart';
import 'package:fintrack/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:fintrack/features/expenses/data/datasources/expenses_remote_ds.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fintrack/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:fintrack/features/expenses/domain/usecases/get_categories_usecase.dart';
import 'package:fintrack/features/expenses/domain/usecases/get_expenses_usecase.dart';
import 'package:fintrack/features/expenses/domain/usecases/search_expenses_usecase.dart';
import 'package:fintrack/features/expenses/domain/usecases/get_previous_expenses_usecase.dart';
import 'package:fintrack/features/expenses/presentation/bloc/expenses_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initExpenses() async {
  // Data sources
  // Use Firestore-backed remote data source
  sl.registerLazySingleton<ExpensesLocalDataSource>(
    () => ExpensesRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ),
  );

  // Repository
  sl.registerLazySingleton<ExpensesRepository>(
    () => ExpensesRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetExpensesUsecase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => SearchExpensesUsecase(sl()));
  sl.registerLazySingleton(() => GetPreviousExpensesUsecase(sl()));

  // Bloc
  sl.registerFactory(
    () => ExpensesBloc(
      getExpenses: sl(),
      getCategories: sl(),
      searchExpenses: sl(),
      getPreviousExpenses: sl(),
    ),
  );
}
