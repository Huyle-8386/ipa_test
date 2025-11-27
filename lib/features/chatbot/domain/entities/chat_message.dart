import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String uid;
  final String message;
  final bool isBot; // đổi tên trường
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.uid,
    required this.message,
    required this.isBot,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, uid, message, isBot, timestamp];
}
