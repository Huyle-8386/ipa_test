import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/money_source_entity.dart';
import '../../../domain/usecases/get_money_sources_usecase.dart';

part 'money_source_event.dart';
part 'money_source_state.dart';

class MoneySourceBloc extends Bloc<MoneySourceEvent, MoneySourceState> {
  final GetMoneySourcesUseCase getMoneySourcesUseCase;

  MoneySourceBloc({required this.getMoneySourcesUseCase})
    : super(MoneySourceInitial()) {
    on<LoadMoneySourcesEvent>(_onLoad);
  }

  Future<void> _onLoad(
    LoadMoneySourcesEvent event,
    Emitter<MoneySourceState> emit,
  ) async {
    // try {
    //   emit(MoneySourceLoading());
    //   final list = await getMoneySourcesUseCase();
    //   emit(MoneySourceLoaded(list));
    // } catch (e) {
    //   emit(MoneySourceError(e.toString()));
    // }

    print("MoneySourceBloc: event received");

    try {
      emit(MoneySourceLoading());
      print("Loading from Firestore...");
      final list = await getMoneySourcesUseCase();
      print("Loaded ${list.length} money sources");
      emit(MoneySourceLoaded(list));
    } catch (e) {
      print("MoneySource ERROR: $e");
      emit(MoneySourceError(e.toString()));
    }
  }
}
