import 'package:fintrack/features/transaction_%20history/data/datasources/transaction_history_local_ds.dart';
import 'package:fintrack/features/transaction_%20history/data/repositories/transaction_history_repository_impl.dart';
import 'package:fintrack/features/transaction_%20history/domain/repositories/transaction_history_repository.dart';
import 'package:fintrack/features/transaction_%20history/domain/usecases/get_filter_types_usecase.dart';
import 'package:fintrack/features/transaction_%20history/domain/usecases/get_transactions_usecase.dart';
import 'package:fintrack/features/transaction_%20history/domain/usecases/search_transactions_usecase.dart';
import 'package:fintrack/features/transaction_%20history/presentation/bloc/transaction_%20history_bloc.dart';

import 'package:fintrack/core/di/injector.dart';

Future<void> initTransactionHistory() async {
  // Data source
  sl.registerLazySingleton<TransactionHistoryLocalDataSource>(
    () => TransactionHistoryLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<TransactionHistoryRepository>(
    () => TransactionHistoryRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTransactionsUsecase(sl()));
  sl.registerLazySingleton(() => SearchTransactionsUsecase(sl()));
  sl.registerLazySingleton(() => GetFilterTypesUsecase(sl()));

  // Bloc
  sl.registerFactory(
    () => TransactionHistoryBloc(
      getTransactions: sl(),
      searchTransactions: sl(),
      getFilterTypes: sl(),
    ),
  );
}
