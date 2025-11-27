import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fintrack/features/transaction_history/data/datasources/transaction_history_remote_ds.dart';
import 'package:fintrack/features/transaction_history/data/repositories/transaction_history_repository_impl.dart';
import 'package:fintrack/features/transaction_history/domain/repositories/transaction_history_repository.dart';
import 'package:fintrack/features/transaction_history/domain/usecases/get_filter_types_usecase.dart';
import 'package:fintrack/features/transaction_history/domain/usecases/get_transactions_usecase.dart';
import 'package:fintrack/features/transaction_history/domain/usecases/search_transactions_usecase.dart';
import 'package:fintrack/features/transaction_history/presentation/bloc/transaction_%20history_bloc.dart';

import 'package:fintrack/core/di/injector.dart';

Future<void> initTransactionHistory() async {
  // 🔥 Remote Data source with Firebase
  sl.registerLazySingleton<TransactionHistoryRemoteDataSource>(
    () => TransactionHistoryRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ),
  );

  // Repository
  sl.registerLazySingleton<TransactionHistoryRepository>(
    () => TransactionHistoryRepositoryImpl(remoteDataSource: sl()),
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
