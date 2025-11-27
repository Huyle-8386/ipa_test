import 'package:bloc/bloc.dart';
import 'package:fintrack/features/auth/domain/usecases/get_current_user.dart';
import '../../domain/usecases/get_chart_data_usecase.dart';
import '../../domain/entities/chart.dart';

part 'chart_event.dart';
part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final GetChartDataUseCase getChartDataUseCase;
  final GetCurrentUser getCurrentUser;

  ChartBloc({required this.getChartDataUseCase, required this.getCurrentUser})
    : super(ChartState.initial()) {
    on<LoadChartDataEvent>(_onLoadData);
    on<ChangeFilterEvent>(_onChangeFilter);
  }

  Future<void> _onLoadData(
    LoadChartDataEvent event,
    Emitter<ChartState> emit,
  ) async {
    final userResult = await getCurrentUser();
    var userName = state.userName;
    userResult.fold((_) {}, (user) {
      if (user.fullName.isNotEmpty) {
        userName = user.fullName;
      } else if (user.email.isNotEmpty) {
        userName = user.email;
      }
    });

    final data = await getChartDataUseCase(state.selectedFilter);
    final incomeChange = calculateChange(data.map((e) => e.income).toList());
    final expenseChange = calculateChange(data.map((e) => e.expense).toList());

    emit(
      state.copyWith(
        chartData: data,
        incomeChangePercent: incomeChange,
        expenseChangePercent: expenseChange,
        userName: userName,
      ),
    );
  }

  Future<void> _onChangeFilter(
    ChangeFilterEvent event,
    Emitter<ChartState> emit,
  ) async {
    final data = await getChartDataUseCase(event.filter);
    final incomeChange = calculateChange(data.map((e) => e.income).toList());
    final expenseChange = calculateChange(data.map((e) => e.expense).toList());
    emit(
      state.copyWith(
        selectedFilter: event.filter,
        chartData: data,
        incomeChangePercent: incomeChange,
        expenseChangePercent: expenseChange,
      ),
    );
  }

  double calculateChange(List<double> values) {
    if (values.length < 2) return 0;

    final oldValue = values[values.length - 2];
    final newValue = values.last;

    if (oldValue == 0) {
      if (newValue == 0)
        return 0;
      else
        return 100;
    }

    return ((newValue - oldValue) / oldValue) * 100;
  }
}
