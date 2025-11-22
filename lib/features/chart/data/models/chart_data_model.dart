import '../../domain/entities/chart.dart';

class ChartDataModel {
  final String day;
  final double income;
  final double expense;

  ChartDataModel({
    required this.day,
    required this.income,
    required this.expense,
  });

  factory ChartDataModel.fromEntity(Chart chart) {
    return ChartDataModel(
      day: chart.day,
      income: chart.income,
      expense: chart.expense,
    );
  }

  Chart toEntity() => Chart(day: day, income: income, expense: expense);
}
