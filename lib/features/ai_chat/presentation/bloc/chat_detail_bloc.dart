import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fintrack/features/ai_chat/domain/entities/chat_message.dart';
import 'package:fintrack/features/ai_chat/domain/usecases/get_messages.dart';
import 'package:fintrack/features/ai_chat/domain/usecases/send_message.dart';
import 'package:fintrack/features/ai_chat/domain/usecases/regenerate_message.dart';

part 'chat_detail_event.dart';
part 'chat_detail_state.dart';

class ChatDetailBloc extends Bloc<ChatDetailEvent, ChatDetailState> {
  final String sessionId;
  final GetMessages getMessages;
  final SendMessage sendMessage;
  final RegenerateMessage regenerateMessage;

  ChatDetailBloc({
    required this.sessionId,
    required this.getMessages,
    required this.sendMessage,
    required this.regenerateMessage,
  }) : super(ChatDetailState.initial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<RegenerateMessageEvent>(_onRegenerateMessage);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await getMessages.call(sessionId);

    result.fold(
      (error) => emit(state.copyWith(isLoading: false, errorMessage: error)),
      (messages) => emit(state.copyWith(messages: messages, isLoading: false)),
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    emit(state.copyWith(isSending: true));

    // Add user message first
    final userMessage = ChatMessage(
      id: '${sessionId}_msg_${DateTime.now().millisecondsSinceEpoch}',
      isUser: true,
      userName: 'Phung Thanh Hao',
      message: event.message,
      time: _formatTime(DateTime.now()),
    );

    final updatedMessages = <ChatMessage>[...state.messages, userMessage];
    emit(state.copyWith(messages: updatedMessages));

    // Get AI response
    final result = await sendMessage(sessionId, event.message);

    result.fold(
      (error) => emit(state.copyWith(isSending: false, errorMessage: error)),
      (aiMessage) {
        final finalMessages = <ChatMessage>[...updatedMessages, aiMessage];
        emit(state.copyWith(messages: finalMessages, isSending: false));
      },
    );
  }

  Future<void> _onRegenerateMessage(
    RegenerateMessageEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    emit(state.copyWith(isSending: true));

    final result = await regenerateMessage(event.messageId);

    result.fold(
      (error) => emit(state.copyWith(isSending: false, errorMessage: error)),
      (regeneratedMessage) {
        final updatedMessages = <ChatMessage>[];
        for (final msg in state.messages) {
          if (msg.id == event.messageId) {
            updatedMessages.add(regeneratedMessage);
          } else {
            updatedMessages.add(msg);
          }
        }

        emit(state.copyWith(messages: updatedMessages, isSending: false));
      },
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
