part of 'chart_bloc.dart';
// import '../../domain/entities/chart.dart';

class ChartState extends Equatable {
  final String selectedFilter;
  final List<Chart> chartData;

  const ChartState({required this.selectedFilter, required this.chartData});

  factory ChartState.initial() {
    return const ChartState(selectedFilter: "Daily", chartData: []);
  }

  ChartState copyWith({String? selectedFilter, List<Chart>? chartData}) {
    return ChartState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      chartData: chartData ?? this.chartData,
    );
  }

  @override
  List<Object?> get props => [selectedFilter, chartData];
}
