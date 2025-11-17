import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/features/home/datasources/account.dart';
import 'package:fintrack/features/home/datasources/list_account.dart';

abstract class HomeEvent {}

class LoadAcountsEvent extends HomeEvent {}

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoadedAccount extends HomeState {
  final List<Account> listAccount;
  HomeLoadedAccount({required this.listAccount});
}

class HomeError extends HomeState {
  final String error;
  HomeError({required this.error});
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadAcountsEvent>((event, emit) {
      emit(HomeLoading());
      final _account = listAccount;
      emit(HomeLoadedAccount(listAccount: _account));
    });
  }
}
