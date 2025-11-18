import 'package:fintrack/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:fintrack/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fintrack/features/auth/domain/repositories/auth_repository.dart';
import 'package:fintrack/features/auth/domain/usecases/sign_in.dart';
import 'package:fintrack/features/auth/domain/usecases/sign_up.dart';
import 'package:fintrack/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:fintrack/features/auth/domain/usecases/validate_email.dart';
import 'package:fintrack/features/auth/domain/usecases/validate_password.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initAuth() async {
  // datasources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // usecases
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => ValidateEmail(sl()));
  sl.registerLazySingleton(() => ValidatePassword(sl()));

  // bloc
  sl.registerFactory(
    () => AuthBloc(
      signIn: sl(),
      signUp: sl(),
      signInWithGoogle: sl(),
      validateEmail: sl(),
      validatePassword: sl(),
    ),
  );
}
