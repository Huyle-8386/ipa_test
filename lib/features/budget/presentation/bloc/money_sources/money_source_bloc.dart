import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_money_sources.dart';
import 'money_source_event.dart';
import 'money_source_state.dart';

class MoneySourceBloc extends Bloc<MoneySourceEvent, MoneySourceState> {
  final GetMoneySources getMoneySources;

  MoneySourceBloc(this.getMoneySources) : super(MoneySourceState.initial()) {
    on<LoadMoneySources>(_onLoad);
  }

  Future<void> _onLoad(
    LoadMoneySources event,
    Emitter<MoneySourceState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    final data = await getMoneySources(event.uid);
    emit(state.copyWith(loading: false, items: data));
  }
}
