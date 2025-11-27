import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/send_user_message.dart';

part 'chat_detail_event.dart';
part 'chat_detail_state.dart';

class ChatDetailBloc extends Bloc<ChatDetailEvent, ChatDetailState> {
  final SendUserMessage sendUserMessage;

  ChatDetailBloc({required this.sendUserMessage})
    : super(ChatDetailState.initial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<RegenerateMessageEvent>(_onRegenerateMessage);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    emit(state.copyWith(isSending: true));

    await sendUserMessage(event.uid, event.message);

    emit(state.copyWith(isSending: false));
  }

  Future<void> _onRegenerateMessage(
    RegenerateMessageEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    emit(state.copyWith(isRegenerating: true));

    await sendUserMessage(event.uid, event.lastUserMessage);

    emit(state.copyWith(isRegenerating: false));
  }
}
