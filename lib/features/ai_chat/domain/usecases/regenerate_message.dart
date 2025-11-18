import 'package:dartz/dartz.dart';
import 'package:fintrack/features/ai_chat/domain/entities/chat_message.dart';
import 'package:fintrack/features/ai_chat/domain/repositories/chat_repository.dart';

class RegenerateMessage {
  final ChatRepository repository;

  RegenerateMessage(this.repository);

  Future<Either<String, ChatMessage>> call(String messageId) async {
    return await repository.regenerateMessage(messageId);
  }
}
