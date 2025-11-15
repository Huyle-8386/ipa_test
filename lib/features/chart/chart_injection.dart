// Data
import 'data/datasources/chart_data_source.dart';
import 'data/repositories/chart_repository_impl.dart';

// Domain
import 'domain/usecases/get_chart_data_usecase.dart';

// Presentation (BLoC)
import 'presentation/bloc/chart_bloc.dart';

class ChartInjection {
  static ChartBloc injectBloc() {
    // 1. Data Source
    final dataSource = ChartDataSource();

    // 2. Repository
    final repository = ChartRepositoryImpl(dataSource);

    // 3. Usecase
    final getChartData = GetChartDataUseCase(repository);

    // 4. Bloc
    return ChartBloc(getChartDataUseCase: getChartData);
  }
}
