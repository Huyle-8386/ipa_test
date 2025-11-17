import 'package:fintrack/features/add_transaction/data/datasource/add_tx_local_ds.dart';
import 'package:fintrack/features/add_transaction/data/repository/add_tx_repository_impl.dart';
import 'package:get_it/get_it.dart';

import 'domain/repositories/add_tx_repository.dart';
import 'domain/usecases/get_categories_usecase.dart';
import 'domain/usecases/get_money_sources_usecase.dart';
import 'domain/usecases/save_transaction_usecase.dart';
import 'presentation/bloc/add_tx_bloc.dart';

final sl = GetIt.instance;

Future<void> initAddTransaction() async {
  // datasources
  sl.registerLazySingleton<AddTxLocalDataSource>(
    () => AddTxLocalDataSourceImpl(),
  );

  // repository
  sl.registerLazySingleton<AddTxRepository>(() => AddTxRepositoryImpl(sl()));

  // usecases
  sl.registerLazySingleton(() => GetCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => GetMoneySourcesUsecase(sl()));
  sl.registerLazySingleton(() => SaveTransactionUsecase(sl()));

  // bloc
  sl.registerFactory(
    () => AddTxBloc(getCategories: sl(), getMoneySources: sl(), saveTx: sl()),
  );
}
