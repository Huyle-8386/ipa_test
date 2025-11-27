import 'package:flutter_bloc/flutter_bloc.dart';
import 'money_source_event.dart';
import 'money_source_state.dart';
import '../../domain/usecases/get_money_sources.dart';
import '../../domain/usecases/add_money_source.dart';
import '../../domain/usecases/update_money_source.dart';
import '../../domain/usecases/delete_money_source.dart';
import '../../domain/entities/money_source_entity.dart';

class MoneySourceBloc extends Bloc<MoneySourceEvent, MoneySourceState> {
  final GetMoneySources getMoneySources;
  final AddMoneySource addMoneySource;
  final UpdateMoneySource updateMoneySource;
  final DeleteMoneySource deleteMoneySource;

  MoneySourceBloc({
    required this.getMoneySources,
    required this.addMoneySource,
    required this.updateMoneySource,
    required this.deleteMoneySource,
  }) : super(MoneySourceInitial()) {
    on<LoadMoneySources>((event, emit) async {
      emit(MoneySourceLoading());
      try {
        final list = await getMoneySources(event.uid);
        emit(MoneySourceLoaded(list));
      } catch (e) {
        emit(MoneySourceError(e.toString()));
      }
    });

    on<AddMoneySourceEvent>((event, emit) async {
      emit(MoneySourceLoading());
      try {
        await addMoneySource(event.uid, event.moneySource);
        final list = await getMoneySources(event.uid);
        emit(MoneySourceLoaded(list));
      } catch (e) {
        emit(MoneySourceError(e.toString()));
      }
    });

    on<UpdateMoneySourceEvent>((event, emit) async {
      emit(MoneySourceLoading());
      try {
        await updateMoneySource(event.uid, event.moneySource);
        final list = await getMoneySources(event.uid);
        emit(MoneySourceLoaded(list));
      } catch (e) {
        emit(MoneySourceError(e.toString()));
      }
    });

    on<DeleteMoneySourceEvent>((event, emit) async {
      emit(MoneySourceLoading());
      try {
        await deleteMoneySource(event.uid, event.id);
        final list = await getMoneySources(event.uid);
        emit(MoneySourceLoaded(list));
      } catch (e) {
        emit(MoneySourceError(e.toString()));
      }
    });
  }
}
