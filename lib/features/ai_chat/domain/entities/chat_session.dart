import 'package:equatable/equatable.dart';

class ChatSession extends Equatable {
  final String id;
  final String title;
  final DateTime lastMessageTime;

  const ChatSession({
    required this.id,
    required this.title,
    required this.lastMessageTime,
  });

  @override
  List<Object?> get props => [id, title, lastMessageTime];
}
