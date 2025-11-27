import '../../domain/entities/chat_message.dart';
import '../model/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<ChatMessageModel>> getMessagesStream(String uid);
  Future<void> addUserMessage(String uid, String message);
  Future<void> addBotMessage(String uid, String message);
}
