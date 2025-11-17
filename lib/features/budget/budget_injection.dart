import 'package:fintrack/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:get_it/get_it.dart';

import 'domain/usecases/get_budgets.dart';
import 'presentation/bloc/budget_bloc.dart';

final sl = GetIt.instance;

Future<void> injectBudgets() async {
  // repository
  sl.registerLazySingleton(() => BudgetRepositoryImpl());

  // usecase
  sl.registerLazySingleton(() => GetBudgets(sl()));

  // bloc
  sl.registerFactory(() => BudgetBloc(getBudgets: sl()));
}
