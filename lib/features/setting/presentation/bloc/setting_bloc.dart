import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/features/auth/domain/usecases/get_current_user.dart';

import '../../domain/entities/setting_card_entity.dart';
import '../../domain/usecase/get_setting_cards_usecase.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final GetSettingCardsUseCase getSettingCardsUseCase;
  final GetCurrentUser getCurrentUser;

  SettingBloc({
    required this.getSettingCardsUseCase,
    required this.getCurrentUser,
  }) : super(SettingInitial()) {
    on<LoadSettingCardsEvent>((event, emit) async {
      final userResult = await getCurrentUser();
      var userName = 'User';
      userResult.fold((_) {}, (user) {
        if (user.fullName.isNotEmpty) {
          userName = user.fullName;
        } else if (user.email.isNotEmpty) {
          userName = user.email;
        }
      });

      final cards = getSettingCardsUseCase();
      emit(SettingLoaded(cards: cards, userName: userName));
    });
  }
}
