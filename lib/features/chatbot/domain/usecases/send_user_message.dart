import '../repositories/chat_repository.dart';

class SendUserMessage {
  final ChatRepository repository;

  SendUserMessage(this.repository);

  Future<void> call(String uid, String message) async {
    await repository.sendUserMessage(uid, message);
  }
}
