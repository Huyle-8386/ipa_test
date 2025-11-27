import 'package:fintrack/features/chart/domain/usecases/get_money_sources_usecase.dart';
import 'package:fintrack/features/auth/domain/usecases/get_current_user.dart';
import 'package:fintrack/features/home/presentation/bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initHome() async {
  sl.registerFactory<HomeBloc>(
    () => HomeBloc(
      getMoneySourcesUseCase: sl<GetMoneySourcesUseCase>(),
      getCurrentUser: sl<GetCurrentUser>(),
    ),
  );
}
