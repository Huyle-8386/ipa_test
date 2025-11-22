import '../entities/chart.dart';

abstract class ChartRepository {
  Future<List<Chart>> getChartData(String filter);
}
