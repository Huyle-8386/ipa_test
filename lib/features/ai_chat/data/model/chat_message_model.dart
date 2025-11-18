import 'package:fintrack/features/ai_chat/domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.isUser,
    required super.userName,
    required super.message,
    required super.time,
    super.showRegenerate = false,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      isUser: json['isUser'] as bool,
      userName: json['userName'] as String,
      message: json['message'] as String,
      time: json['time'] as String,
      showRegenerate: json['showRegenerate'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isUser': isUser,
      'userName': userName,
      'message': message,
      'time': time,
      'showRegenerate': showRegenerate,
    };
  }

  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      id: entity.id,
      isUser: entity.isUser,
      userName: entity.userName,
      message: entity.message,
      time: entity.time,
      showRegenerate: entity.showRegenerate,
    );
  }
}
