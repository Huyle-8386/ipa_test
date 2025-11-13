import 'package:fintrack/features/add_transaction/data/datasource/add_tx_local_ds.dart';
import 'package:fintrack/features/add_transaction/data/repository/add_tx_repository_impl.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/add_tx_repository.dart';
import 'package:fintrack/features/add_transaction/domain/usecases/get_categories_usecase.dart';
import 'package:fintrack/features/add_transaction/domain/usecases/get_money_sources_usecase.dart';
import 'package:fintrack/features/add_transaction/domain/usecases/save_transaction_usecase.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ========== Data sources ==========
  // Nếu chưa có class này, tạo theo mock local (đọc cứng/asset/DB)
  sl.registerLazySingleton<AddTxLocalDataSource>(() => AddTxLocalDataSourceImpl());

  // ========== Repository ==========
  sl.registerLazySingleton<AddTxRepository>(() => AddTxRepositoryImpl(sl()));

  // ========== Usecases ==========
  sl.registerLazySingleton(() => GetCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => GetMoneySourcesUsecase(sl()));
  sl.registerLazySingleton(() => SaveTransactionUsecase(sl()));

  // ========== Bloc ==========
  sl.registerFactory(() => AddTxBloc(
        getCategories: sl(),
        getMoneySources: sl(),
        saveTx: sl(),
      ));
}