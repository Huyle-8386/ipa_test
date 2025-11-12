part of 'chat_detail_bloc.dart';

class ChatDetailState extends Equatable {
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isSending;
  final String? errorMessage;

  const ChatDetailState({
    required this.messages,
    required this.isLoading,
    required this.isSending,
    this.errorMessage,
  });

  factory ChatDetailState.initial() {
    return const ChatDetailState(
      messages: [],
      isLoading: false,
      isSending: false,
    );
  }

  ChatDetailState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isSending,
    String? errorMessage,
  }) {
    return ChatDetailState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [messages, isLoading, isSending, errorMessage];
}
