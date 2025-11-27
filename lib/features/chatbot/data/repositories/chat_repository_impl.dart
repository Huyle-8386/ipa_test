import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasource/chat_remote_data_source.dart';
import '../model/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;

  ChatRepositoryImpl(this.remote);

  @override
  Stream<List<ChatMessage>> getMessagesStream(String uid) {
    return remote.getMessagesStream(uid);
  }

  @override
  Future<void> sendUserMessage(String uid, String message) {
    return remote.addUserMessage(uid, message);
  }

  @override
  Future<void> sendBotMessage(String uid, String message) {
    return remote.addBotMessage(uid, message);
  }
}
