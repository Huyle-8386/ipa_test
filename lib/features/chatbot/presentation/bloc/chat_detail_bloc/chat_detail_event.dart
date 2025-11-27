part of 'chat_detail_bloc.dart';

abstract class ChatDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatDetailEvent {
  final String uid;
  final String message;

  SendMessageEvent(this.uid, this.message);

  @override
  List<Object?> get props => [uid, message];
}

class RegenerateMessageEvent extends ChatDetailEvent {
  final String uid;
  final String lastUserMessage;

  RegenerateMessageEvent(this.uid, this.lastUserMessage);

  @override
  List<Object?> get props => [uid, lastUserMessage];
}
