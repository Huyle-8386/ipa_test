part of 'chart_bloc.dart';

class ChartState {
  final String selectedFilter;
  final List<Chart> chartData;
  final double incomeChangePercent;
  final double expenseChangePercent;
  final String userName;

  ChartState({
    required this.selectedFilter,
    required this.chartData,
    required this.incomeChangePercent,
    required this.expenseChangePercent,
    required this.userName,
  });

  factory ChartState.initial() => ChartState(
    selectedFilter: 'Weekly',
    chartData: [],
    incomeChangePercent: 0.0,
    expenseChangePercent: 0.0,
    userName: 'User',
  );

  ChartState copyWith({
    String? selectedFilter,
    List<Chart>? chartData,
    double? incomeChangePercent,
    double? expenseChangePercent,
    String? userName,
  }) {
    return ChartState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      chartData: chartData ?? this.chartData,
      incomeChangePercent: incomeChangePercent ?? this.incomeChangePercent,
      expenseChangePercent: expenseChangePercent ?? this.expenseChangePercent,
      userName: userName ?? this.userName,
    );
  }
}
