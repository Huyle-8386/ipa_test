import '../entities/chart.dart';
import '../repositories/chart_repository.dart';

class GetChartDataUseCase {
  final ChartRepository repository;
  GetChartDataUseCase(this.repository);

  Future<List<Chart>> call(String filter) async {
    return repository.getChartData(filter);
  }
}
