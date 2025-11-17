// Data
import 'data/datasources/chart_data_source.dart';
import 'data/repositories/chart_repository_impl.dart';

// Domain
import 'domain/repositories/chart_repository.dart';
import 'domain/usecases/get_chart_data_usecase.dart';

// Presentation (BLoC)
import 'presentation/bloc/chart_bloc.dart';

import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initChartFeature() async {
  // 1. Data Source
  sl.registerLazySingleton<ChartDataSource>(() => ChartDataSource());

  // 2. Repository
  sl.registerLazySingleton<ChartRepository>(() => ChartRepositoryImpl(sl()));

  // 3. Usecase
  sl.registerLazySingleton(() => GetChartDataUseCase(sl()));

  // 4. Bloc
  sl.registerFactory(() => ChartBloc(getChartDataUseCase: sl()));
}
