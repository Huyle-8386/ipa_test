import 'package:dartz/dartz.dart';
import 'package:fintrack/features/ai_chat/domain/entities/chat_message.dart';
import 'package:fintrack/features/ai_chat/domain/repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<Either<String, ChatMessage>> call(String sessionId, String message) async {
    return await repository.sendMessage(sessionId, message);
  }
}
