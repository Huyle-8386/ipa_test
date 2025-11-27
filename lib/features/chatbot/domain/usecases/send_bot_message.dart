import '../repositories/chat_repository.dart';

class SendBotMessage {
  final ChatRepository repository;

  SendBotMessage(this.repository);

  Future<void> call(String uid, String message) async {
    await repository.sendBotMessage(uid, message);
  }
}
