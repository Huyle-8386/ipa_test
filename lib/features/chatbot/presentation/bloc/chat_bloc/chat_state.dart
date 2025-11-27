part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final bool isLoading;
  final List<ChatMessage> messages;
  final bool isBotTyping;

  const ChatState({
    required this.isLoading,
    required this.messages,
    required this.isBotTyping,
  });

  factory ChatState.initial() {
    return const ChatState(isLoading: false, messages: [], isBotTyping: false);
  }

  ChatState copyWith({
    bool? isLoading,
    List<ChatMessage>? messages,
    bool? isBotTyping,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      messages: messages ?? this.messages,
      isBotTyping: isBotTyping ?? this.isBotTyping,
    );
  }

  @override
  List<Object?> get props => [isLoading, messages, isBotTyping];
}
