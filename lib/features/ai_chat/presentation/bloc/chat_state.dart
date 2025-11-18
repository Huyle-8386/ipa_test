part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final List<ChatSession> sessions;
  final bool isLoading;
  final String? errorMessage;
  final String? newSessionId;

  const ChatState({
    required this.sessions,
    required this.isLoading,
    this.errorMessage,
    this.newSessionId,
  });

  factory ChatState.initial() {
    return const ChatState(sessions: [], isLoading: false);
  }

  ChatState copyWith({
    List<ChatSession>? sessions,
    bool? isLoading,
    String? errorMessage,
    String? newSessionId,
  }) {
    return ChatState(
      sessions: sessions ?? this.sessions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      newSessionId: newSessionId,
    );
  }

  @override
  List<Object?> get props => [sessions, isLoading, errorMessage, newSessionId];
}
