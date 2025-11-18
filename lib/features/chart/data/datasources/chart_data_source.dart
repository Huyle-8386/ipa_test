import '../models/chart_data_model.dart';

class ChartDataSource {
  static final List<ChartDataModel> dailyData = [
    ChartDataModel(day: "Mon", income: 500, expense: 300),
    ChartDataModel(day: "Tue", income: 600, expense: 250),
    ChartDataModel(day: "Wed", income: 100, expense: 600),
    ChartDataModel(day: "Thu", income: 700, expense: 400),
    ChartDataModel(day: "Fri", income: 650, expense: 350),
    ChartDataModel(day: "Sat", income: 200, expense: 500),
    ChartDataModel(day: "Sun", income: 750, expense: 450),
  ];

  static final List<ChartDataModel> weeklyData = [
    ChartDataModel(day: "W1", income: 1000, expense: 2500),
    ChartDataModel(day: "W2", income: 2500, expense: 1500),
    ChartDataModel(day: "W3", income: 1500, expense: 2800),
    ChartDataModel(day: "W4", income: 3300, expense: 1600),
  ];

  static final List<ChartDataModel> monthlyData = [
    ChartDataModel(day: "1", income: 4500, expense: 3200),
    ChartDataModel(day: "2", income: 4800, expense: 3100),
    ChartDataModel(day: "3", income: 6200, expense: 4500),
    ChartDataModel(day: "4", income: 5100, expense: 3300),
    ChartDataModel(day: "5", income: 2600, expense: 4700),
    ChartDataModel(day: "6", income: 6000, expense: 4000),
    ChartDataModel(day: "7", income: 5800, expense: 4900),
    ChartDataModel(day: "8", income: 3200, expense: 6200),
    ChartDataModel(day: "9", income: 5900, expense: 3800),
    ChartDataModel(day: "10", income: 6400, expense: 4300),
    ChartDataModel(day: "11", income: 6300, expense: 4100),
    ChartDataModel(day: "12", income: 6500, expense: 4400),
  ];

  static final List<ChartDataModel> yearlyData = [
    ChartDataModel(day: "2020", income: 58000, expense: 42000),
    ChartDataModel(day: "2021", income: 60000, expense: 43000),
    ChartDataModel(day: "2022", income: 64000, expense: 46000),
    ChartDataModel(day: "2023", income: 68000, expense: 49000),
    ChartDataModel(day: "2024", income: 72000, expense: 51000),
  ];

  List<ChartDataModel> getDataByFilter(String filter) {
    switch (filter) {
      case "Daily":
        return dailyData;
      case "Weekly":
        return weeklyData;
      case "Monthly":
        return monthlyData;
      case "Yearly":
        return yearlyData;
      default:
        return weeklyData;
    }
  }
}
