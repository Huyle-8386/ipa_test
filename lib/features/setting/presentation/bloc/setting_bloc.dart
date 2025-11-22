import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/setting_card_entity.dart';
import '../../domain/usecase/get_setting_cards_usecase.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final GetSettingCardsUseCase getSettingCardsUseCase;

  SettingBloc({required this.getSettingCardsUseCase})
    : super(SettingInitial()) {
    on<LoadSettingCardsEvent>((event, emit) {
      final cards = getSettingCardsUseCase();
      emit(SettingLoaded(cards: cards));
    });
  }
}
