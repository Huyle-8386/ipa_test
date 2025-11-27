import '../entities/chat_message.dart';

abstract class ChatRepository {
  Stream<List<ChatMessage>> getMessagesStream(String uid);
  Future<void> sendUserMessage(String uid, String message);
  Future<void> sendBotMessage(String uid, String message);
}
