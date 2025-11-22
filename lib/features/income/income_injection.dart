import 'package:fintrack/features/income/data/datasources/income_data.dart';
import 'package:fintrack/features/income/data/repositories/income_repository_impl.dart';
import 'package:fintrack/features/income/domain/repositories/income_repository.dart';
import 'package:fintrack/features/income/domain/usecases/get_income_categories_usecase.dart';
import 'package:fintrack/features/income/domain/usecases/get_income_usecase.dart';
import 'package:fintrack/features/income/domain/usecases/search_income_usecase.dart';
import 'package:fintrack/features/income/presentation/bloc/income_bloc.dart';

import '../../core/di/injector.dart';

Future<void> initIncome() async {
  // Data sources
  sl.registerLazySingleton<IncomeLocalDataSource>(
    () => IncomeLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<IncomeRepository>(() => IncomeRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetIncomeUsecase(sl()));
  sl.registerLazySingleton(() => GetIncomeCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => SearchIncomeUsecase(sl()));

  // Bloc
  sl.registerFactory(
    () => IncomeBloc(getIncome: sl(), getCategories: sl(), searchIncome: sl()),
  );
}
