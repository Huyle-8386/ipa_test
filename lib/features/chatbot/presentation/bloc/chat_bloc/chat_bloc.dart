import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/chat_message.dart';
import '../../../domain/usecases/get_messages_stream.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessagesStream getMessagesStream;

  StreamSubscription? _subscription;

  ChatBloc({required this.getMessagesStream}) : super(ChatState.initial()) {
    on<LoadMessages>(_onLoadMessages);
    on<NewMessagesEvent>(_onNewMessages);
    on<UserSendMessageEvent>(_onUserSendMessage);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    _subscription?.cancel();
    _subscription = getMessagesStream(event.uid).listen((messages) {
      add(NewMessagesEvent(messages));
    });

    emit(state.copyWith(isLoading: false));
  }

  void _onUserSendMessage(UserSendMessageEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(isBotTyping: true));
  }
  // void _onNewMessages(NewMessagesEvent event, Emitter<ChatState> emit) {
  //   emit(state.copyWith(messages: event.messages));
  // }

  void _onNewMessages(NewMessagesEvent event, Emitter<ChatState> emit) {
    final sorted = [...event.messages]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    bool isBotTyping = state.isBotTyping;

    if (sorted.isNotEmpty) {
      final last = sorted.last;

      if (last.isBot) {
        // Bot đã trả lời → dừng hiển thị "AI đang trả lời..."
        isBotTyping = false;
      }
    }

    emit(state.copyWith(messages: sorted, isBotTyping: isBotTyping));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
