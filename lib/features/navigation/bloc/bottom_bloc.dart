import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BottomEvent {}

class LoadPageEvent extends BottomEvent {
  final int index;
  LoadPageEvent({required this.index});
}

abstract class BottomState {}

class InitialBottom extends BottomState {}

class LoadedBottom extends BottomState {
  final int currentIndex;
  LoadedBottom({required this.currentIndex});
}

class BottomBloc extends Bloc<BottomEvent, BottomState> {
  int _currentIndex = 0;
  BottomBloc() : super(InitialBottom()) {
    on<LoadPageEvent>((event, emit) {
      _currentIndex = event.index;
      emit(LoadedBottom(currentIndex: _currentIndex));
    });
  }
}
