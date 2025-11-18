import 'package:fintrack/features/ai_chat/domain/entities/chat_session.dart';

class ChatSessionModel extends ChatSession {
  const ChatSessionModel({
    required super.id,
    required super.title,
    required super.lastMessageTime,
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    return ChatSessionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      lastMessageTime: DateTime.parse(json['lastMessageTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lastMessageTime': lastMessageTime.toIso8601String(),
    };
  }

  factory ChatSessionModel.fromEntity(ChatSession entity) {
    return ChatSessionModel(
      id: entity.id,
      title: entity.title,
      lastMessageTime: entity.lastMessageTime,
    );
  }
}
