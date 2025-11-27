import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class GetMessagesStream {
  final ChatRepository repository;

  GetMessagesStream(this.repository);

  Stream<List<ChatMessage>> call(String uid) {
    return repository.getMessagesStream(uid);
  }
}
