import 'package:get_it/get_it.dart';
import 'data/datasource/setting_datasource.dart';
import 'data/repositories/setting_repository_impl.dart';
import 'domain/repositories/setting_repository.dart';
import 'domain/usecase/get_setting_cards_usecase.dart';
import 'presentation/bloc/setting_bloc.dart';
import 'package:fintrack/features/auth/domain/usecases/get_current_user.dart';

final sl = GetIt.instance;

Future<void> initSettingFeature() async {
  // Datasource
  sl.registerLazySingleton<SettingDatasource>(() => SettingDatasource());

  // Repository
  sl.registerLazySingleton<SettingRepository>(
    () => SettingRepositoryImpl(datasource: sl()),
  );

  // UseCase
  sl.registerLazySingleton<GetSettingCardsUseCase>(
    () => GetSettingCardsUseCase(repository: sl()),
  );

  // Bloc (no event dispatch here)
  sl.registerFactory<SettingBloc>(
    () => SettingBloc(
      getSettingCardsUseCase: sl(),
      getCurrentUser: sl<GetCurrentUser>(),
    ),
  );
}
