import 'package:fintrack/features/income/data/datasources/income_data.dart';
import 'package:fintrack/features/income/data/datasources/income_remote_ds.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fintrack/features/income/data/repositories/income_repository_impl.dart';
import 'package:fintrack/features/income/domain/repositories/income_repository.dart';
import 'package:fintrack/features/income/domain/usecases/get_income_categories_usecase.dart';
import 'package:fintrack/features/income/domain/usecases/get_income_usecase.dart';
import 'package:fintrack/features/income/domain/usecases/search_income_usecase.dart';
import 'package:fintrack/features/income/domain/usecases/get_previous_income_usecase.dart';
import 'package:fintrack/features/income/presentation/bloc/income_bloc.dart';

import '../../core/di/injector.dart';

Future<void> initIncome() async {
  // Data sources - use Firestore remote implementation
  sl.registerLazySingleton<IncomeLocalDataSource>(
    () => IncomeRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ),
  );

  // Repository
  sl.registerLazySingleton<IncomeRepository>(() => IncomeRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetIncomeUsecase(sl()));
  sl.registerLazySingleton(() => GetIncomeCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => SearchIncomeUsecase(sl()));
  sl.registerLazySingleton(() => GetPreviousIncomeUsecase(sl()));

  // Bloc
  sl.registerFactory(
    () => IncomeBloc(
      getIncome: sl(),
      getCategories: sl(),
      searchIncome: sl(),
      getPreviousIncome: sl(),
    ),
  );
}
