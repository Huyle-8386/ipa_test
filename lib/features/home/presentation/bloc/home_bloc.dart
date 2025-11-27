import 'package:fintrack/features/auth/domain/usecases/get_current_user.dart';
import 'package:fintrack/features/chart/domain/usecases/get_money_sources_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMoneySourcesUseCase getMoneySourcesUseCase;
  final GetCurrentUser getCurrentUser;

  HomeBloc({required this.getMoneySourcesUseCase, required this.getCurrentUser})
    : super(HomeInitial()) {
    on<HomeStarted>(_onStarted);
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final userResult = await getCurrentUser();
      String userName = 'User';
      userResult.fold((_) {}, (user) {
        if (user.fullName.isNotEmpty) {
          userName = user.fullName;
        } else if (user.email.isNotEmpty) {
          userName = user.email;
        }
      });

      final sources = await getMoneySourcesUseCase();
      final total = sources.fold<double>(
        0,
        (prev, item) => prev + item.balance,
      );
      emit(
        HomeLoaded(
          userName: userName,
          totalBalance: total,
          moneySources: sources,
        ),
      );
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
