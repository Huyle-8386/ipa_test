part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMessages extends ChatEvent {
  final String uid;

  LoadMessages(this.uid);

  @override
  List<Object?> get props => [uid];
}

class NewMessagesEvent extends ChatEvent {
  final List<ChatMessage> messages;

  NewMessagesEvent(this.messages);

  @override
  List<Object?> get props => [messages];
}

class UserSendMessageEvent extends ChatEvent {}
