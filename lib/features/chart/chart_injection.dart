import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// =========================
//       DATA
// =========================
import 'data/datasources/chart_data_source.dart';
import 'data/datasources/money_source_remote_data_source.dart';
import 'data/datasources/transaction_remote_data_source.dart';

import 'data/repositories/chart_repository_impl.dart';
import 'data/repositories/money_source_repository_impl.dart';
import 'data/repositories/transaction_repository_impl.dart';

// =========================
//       DOMAIN
// =========================
import 'domain/repositories/chart_repository.dart';
import 'domain/repositories/money_source_repository.dart';
import 'domain/repositories/transaction_repository.dart';

import 'domain/usecases/get_chart_data_usecase.dart';
import 'domain/usecases/get_money_sources_usecase.dart';
import 'domain/usecases/get_transactions_usecase.dart';

// =========================
//       PRESENTATION
// =========================
import 'presentation/bloc/chart_bloc.dart';
import 'presentation/bloc/money_source/money_source_bloc.dart';

final sl = GetIt.instance;

Future<void> initChartFeature() async {
  // =====================================================
  //                    CHART FEATURE
  // =====================================================

  /// Data Source
  sl.registerLazySingleton<ChartDataSource>(
    () => ChartDataSource(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ),
  );

  /// Repository
  sl.registerLazySingleton<ChartRepository>(() => ChartRepositoryImpl(sl()));

  /// Usecase
  sl.registerLazySingleton(() => GetChartDataUseCase(sl()));

  /// Bloc
  sl.registerFactory(() => ChartBloc(getChartDataUseCase: sl()));

  // =====================================================
  //               MONEY SOURCE FEATURE
  // =====================================================

  /// Data Source
  sl.registerLazySingleton<MoneySourceRemoteDataSource>(
    () => MoneySourceRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ),
  );

  /// Repository
  sl.registerLazySingleton<MoneySourceRepository>(
    () => MoneySourceRepositoryImpl(remote: sl()),
  );

  /// Usecase
  sl.registerLazySingleton(() => GetMoneySourcesUseCase(sl()));

  /// Bloc
  sl.registerFactory(() => MoneySourceBloc(getMoneySourcesUseCase: sl()));

  // =====================================================
  //              TRANSACTION FEATURE
  // =====================================================

  /// Data Source
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ),
  );

  /// Repository
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(remote: sl()),
  );

  /// Usecase
  sl.registerLazySingleton(() => GetTransactionsUseCase(sl()));
}
