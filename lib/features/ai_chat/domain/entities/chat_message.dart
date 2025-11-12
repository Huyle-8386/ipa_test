import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final bool isUser;
  final String userName;
  final String message;
  final String time;
  final bool showRegenerate;

  const ChatMessage({
    required this.id,
    required this.isUser,
    required this.userName,
    required this.message,
    required this.time,
    this.showRegenerate = false,
  });

  @override
  List<Object?> get props => [id, isUser, userName, message, time, showRegenerate];
}
