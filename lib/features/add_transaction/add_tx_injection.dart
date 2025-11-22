import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/add_transaction/data/datasource/%20category_remote_datasource.dart';
import 'package:fintrack/features/add_transaction/data/datasource/%20moneysource_remote_datasource.dart';

import 'package:fintrack/features/add_transaction/data/datasource/add_tx_remote_datasource.dart';
import 'package:fintrack/features/add_transaction/data/repository/add_tx_repository_impl.dart';
import 'package:fintrack/features/add_transaction/data/repository/category_repository_impl.dart';
import 'package:fintrack/features/add_transaction/data/repository/moneysource_repository_impl.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/%20moneysource_repository.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/category_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'domain/repositories/add_tx_repository.dart';
import 'domain/usecases/get_categories_usecase.dart';
import 'domain/usecases/get_money_sources_usecase.dart';
import 'domain/usecases/save_transaction_usecase.dart';
import 'presentation/bloc/add_tx_bloc.dart';

final sl = GetIt.instance;

Future<void> initAddTransaction() async {
  // datasources
  sl.registerLazySingleton<AddTxRemoteDataSource>(
    () => AddTxRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ),
  );
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSource(
      FirebaseFirestore.instance, // Dùng instance đã có
      // Nếu constructor CategoryRemoteDataSource của bạn không dùng FirebaseAuth, chỉ cần truyền firestore.
    ),
  );

  // Đăng ký CategoryRepository (Sử dụng implementation)
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      sl(),
    ), // sl() sẽ tự động cung cấp CategoryRemoteDataSource đã đăng ký ở trên.
  );

  sl.registerLazySingleton<MoneySourceRemoteDataSource>(
    () => MoneySourceRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ),
  );

  // Đăng ký MoneySourceRepository
  sl.registerLazySingleton<MoneySourceRepository>(
    // sl() sẽ tự động cung cấp MoneySourceRemoteDataSource
    () => MoneySourceRepositoryImpl(sl()),
  );

  // Đăng ký CategoryRemoteDataSource

  // repository
  sl.registerLazySingleton<AddTxRepository>(() => AddTxRepositoryImpl(sl()));

  // usecases

  sl.registerLazySingleton(() => GetCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => GetMoneySourcesUsecase(sl()));
  // sl.registerLazySingleton(() => SaveTransactionUsecase(sl()));
  sl.registerLazySingleton<SaveTransactionUsecase>(
    () => SaveTransactionUsecase(sl()),
  );

  // bloc
  // sl.registerFactory(
  //   () => AddTxBloc(getCategories: sl(), getMoneySources: sl(), saveTx: sl()),
  // );
  sl.registerFactory(
    () => AddTxBloc(getCategories: sl(), getMoneySources: sl(), saveTx: sl()),
  );
}
