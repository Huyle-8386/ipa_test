import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:fintrack/features/budget/data/repositories/category_repository_impl.dart';
import 'package:fintrack/features/budget/domain/repositories/budget_repository.dart';
import 'package:fintrack/features/budget/domain/repositories/category_repository.dart';
import 'package:fintrack/features/budget/domain/usecases/get_categories.dart';
import 'package:fintrack/features/budget/presentation/bloc/category/category_bloc.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/budget_remote_data_source.dart';
import 'data/datasources/category_remote_datasource.dart';
import 'data/datasources/money_source_remote_data_source.dart';
import 'data/repositories/money_source_repository_impl.dart';
import 'domain/repositories/money_source_repository.dart';
import 'domain/usecases/add_budget.dart';
import 'domain/usecases/delete_budget.dart';
import 'domain/usecases/get_budgets.dart';
import 'domain/usecases/get_money_sources.dart';
import 'domain/usecases/update_budget.dart';
import 'presentation/bloc/budget_bloc.dart';
import 'presentation/bloc/money_sources/money_source_bloc.dart';

final sl = GetIt.instance;

Future<void> injectBudgets() async {
  // // repository
  // //sl.registerLazySingleton(() => BudgetRepositoryImpl());

  // // usecase
  // sl.registerLazySingleton(() => GetBudgets(sl()));

  // // bloc
  // sl.registerFactory(() => BudgetBloc(getBudgets: sl()));

  // // repository
  // sl.registerLazySingleton<BudgetRepository>(() => BudgetRepositoryImpl());

  //=========CRUD
  // data sources
  sl.registerLazySingleton(
    () => BudgetRemoteDataSource(FirebaseFirestore.instance),
  );

  // repositories
  sl.registerLazySingleton<BudgetRepository>(() => BudgetRepositoryImpl(sl()));

  // usecases
  sl.registerLazySingleton(() => AddBudget(sl()));
  sl.registerLazySingleton(() => GetBudgets(sl()));
  sl.registerLazySingleton(() => UpdateBudget(sl()));
  sl.registerLazySingleton(() => DeleteBudget(sl()));

  // bloc
  sl.registerFactory(
    () => BudgetBloc(
      addBudgetUsecase: sl(),
      getBudgetsUsecase: sl(),
      updateBudgetUsecase: sl(),
      deleteBudgetUsecase: sl(),
    ),
  );

  // sl.registerLazySingleton(() => FirebaseFirestore.instance);

  //============== CATEGORY
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSource(FirebaseFirestore.instance),
  );

  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl<CategoryRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetCategories>(
    () => GetCategories(sl<CategoryRepository>()),
  );

  sl.registerFactory<CategoryBloc>(() => CategoryBloc(sl<GetCategories>()));

  //=============== MONEY SOURCE
  sl.registerLazySingleton<MoneySourceRemoteDataSource>(
    () => MoneySourceRemoteDataSource(FirebaseFirestore.instance),
  );

  sl.registerLazySingleton<MoneySourceRepository>(
    () => MoneySourceRepositoryImpl(sl<MoneySourceRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetMoneySources>(
    () => GetMoneySources(sl<MoneySourceRepository>()),
  );

  sl.registerFactory<MoneySourceBloc>(
    () => MoneySourceBloc(sl<GetMoneySources>()),
  );
}
