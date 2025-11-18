import '../../domain/entities/chart.dart';
import '../../domain/repositories/chart_repository.dart';
import '../datasources/chart_data_source.dart';

class ChartRepositoryImpl implements ChartRepository {
  final ChartDataSource dataSource;

  ChartRepositoryImpl(this.dataSource);

  @override
  Future<List<Chart>> getChartData(String filter) async {
    final dataModels = dataSource.getDataByFilter(filter);
    return dataModels.map((e) => e.toEntity()).toList();
  }
}
