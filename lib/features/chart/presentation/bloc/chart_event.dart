part of 'chart_bloc.dart';

abstract class ChartEvent {}

class LoadChartDataEvent extends ChartEvent {}

class ChangeFilterEvent extends ChartEvent {
  final String filter;
  ChangeFilterEvent(this.filter);
}
