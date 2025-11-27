part of 'chat_detail_bloc.dart';

class ChatDetailState extends Equatable {
  final bool isSending;
  final bool isRegenerating;

  const ChatDetailState({
    required this.isSending,
    required this.isRegenerating,
  });

  factory ChatDetailState.initial() {
    return const ChatDetailState(isSending: false, isRegenerating: false);
  }

  ChatDetailState copyWith({bool? isSending, bool? isRegenerating}) {
    return ChatDetailState(
      isSending: isSending ?? this.isSending,
      isRegenerating: isRegenerating ?? this.isRegenerating,
    );
  }

  @override
  List<Object?> get props => [isSending, isRegenerating];
}
