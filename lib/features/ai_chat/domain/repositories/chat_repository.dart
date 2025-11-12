import 'package:dartz/dartz.dart';
import 'package:fintrack/features/ai_chat/domain/entities/chat_session.dart';
import 'package:fintrack/features/ai_chat/domain/entities/chat_message.dart';

abstract class ChatRepository {
  Future<Either<String, List<ChatSession>>> getChatSessions();
  Future<Either<String, ChatSession>> createNewSession();
  Future<Either<String, List<ChatMessage>>> getMessages(String sessionId);
  Future<Either<String, ChatMessage>> sendMessage(String sessionId, String message);
  Future<Either<String, ChatMessage>> regenerateMessage(String messageId);
}
