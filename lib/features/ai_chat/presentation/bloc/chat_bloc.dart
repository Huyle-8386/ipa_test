import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fintrack/features/ai_chat/domain/entities/chat_session.dart';
import 'package:fintrack/features/ai_chat/domain/usecases/get_chat_sessions.dart';
import 'package:fintrack/features/ai_chat/domain/usecases/create_new_chat_session.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatSessions getChatSessions;
  final CreateNewChatSession createNewChatSession;

  ChatBloc({required this.getChatSessions, required this.createNewChatSession})
    : super(ChatState.initial()) {
    on<LoadChatSessions>(_onLoadChatSessions);
    on<CreateNewChatSessionEvent>(_onCreateNewChatSession);
  }

  Future<void> _onLoadChatSessions(
    LoadChatSessions event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await getChatSessions();

    result.fold(
      (error) => emit(state.copyWith(isLoading: false, errorMessage: error)),
      (sessions) => emit(state.copyWith(sessions: sessions, isLoading: false)),
    );
  }

  Future<void> _onCreateNewChatSession(
    CreateNewChatSessionEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await createNewChatSession.call();

    result.fold(
      (error) => emit(state.copyWith(isLoading: false, errorMessage: error)),
      (newSession) {
        final updatedSessions = <ChatSession>[newSession, ...state.sessions];
        emit(
          state.copyWith(
            sessions: updatedSessions,
            isLoading: false,
            newSessionId: newSession.id,
          ),
        );
        // Reset newSessionId after emitting
        emit(state.copyWith(newSessionId: null));
      },
    );
  }
}
