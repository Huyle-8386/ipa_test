part of 'chart_bloc.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();

  @override
  List<Object?> get props => [];
}

class LoadChartDataEvent extends ChartEvent {}

class ChangeFilterEvent extends ChartEvent {
  final String filter;
  const ChangeFilterEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}
