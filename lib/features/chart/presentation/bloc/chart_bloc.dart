import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/chart.dart';
import '../../domain/usecases/get_chart_data_usecase.dart';

part 'chart_event.dart';
part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final GetChartDataUseCase getChartDataUseCase;

  ChartBloc({required this.getChartDataUseCase}) : super(ChartState.initial()) {
    on<LoadChartDataEvent>(_onLoadData);
    on<ChangeFilterEvent>(_onChangeFilter);
  }

  Future<void> _onLoadData(
    LoadChartDataEvent event,
    Emitter<ChartState> emit,
  ) async {
    final data = await getChartDataUseCase(state.selectedFilter);
    emit(state.copyWith(chartData: data));
  }

  Future<void> _onChangeFilter(
    ChangeFilterEvent event,
    Emitter<ChartState> emit,
  ) async {
    final data = await getChartDataUseCase(event.filter);
    emit(state.copyWith(selectedFilter: event.filter, chartData: data));
  }
}
