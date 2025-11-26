import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Data
import 'data/datasource/money_source_remote_data_source.dart';
import 'data/repositories/money_source_repository_impl.dart';

// Domain
import 'domain/usecases/add_money_source.dart';
import 'domain/usecases/get_money_sources.dart';
import 'domain/usecases/update_money_source.dart';
import 'domain/usecases/delete_money_source.dart';
import 'domain/usecases/check_user_has_money_source.dart';

// Bloc
import 'presentation/bloc/money_source_bloc.dart';

final sl = GetIt.instance;

Future<void> initMoneySource() async {
  // Firebase (chỉ đăng ký nếu chưa có)
  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
  }
  if (!sl.isRegistered<FirebaseAuth>()) {
    sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  }

  // DataSource
  sl.registerLazySingleton<MoneySourceRemoteDataSource>(
    () => MoneySourceRemoteDataSourceImpl(
      sl<FirebaseFirestore>(),
      sl<FirebaseAuth>(),
    ),
  );

  // Repository
  sl.registerLazySingleton(
    () => MoneySourceRepositoryImpl(sl<MoneySourceRemoteDataSource>()),
  );

  // UseCases
  sl.registerLazySingleton(
    () => AddMoneySource(sl<MoneySourceRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => GetMoneySources(sl<MoneySourceRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => UpdateMoneySource(sl<MoneySourceRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => DeleteMoneySource(sl<MoneySourceRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => CheckUserHasMoneySourceUseCase(sl<MoneySourceRepositoryImpl>()),
  );

  // Bloc
  sl.registerFactory(
    () => MoneySourceBloc(
      getMoneySources: sl<GetMoneySources>(),
      addMoneySource: sl<AddMoneySource>(),
      updateMoneySource: sl<UpdateMoneySource>(),
      deleteMoneySource: sl<DeleteMoneySource>(),
    ),
  );
}
