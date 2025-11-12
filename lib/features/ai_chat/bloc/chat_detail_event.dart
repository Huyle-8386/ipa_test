part of 'chat_detail_bloc.dart';

abstract class ChatDetailEvent extends Equatable {
  const ChatDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadMessages extends ChatDetailEvent {}

class SendMessageEvent extends ChatDetailEvent {
  final String message;

  const SendMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class RegenerateMessageEvent extends ChatDetailEvent {
  final String messageId;

  const RegenerateMessageEvent(this.messageId);

  @override
  List<Object?> get props => [messageId];
}
