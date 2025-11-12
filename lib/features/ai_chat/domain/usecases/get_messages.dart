import 'package:dartz/dartz.dart';
import 'package:fintrack/features/ai_chat/domain/entities/chat_message.dart';
import 'package:fintrack/features/ai_chat/domain/repositories/chat_repository.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Future<Either<String, List<ChatMessage>>> call(String sessionId) async {
    return await repository.getMessages(sessionId);
  }
}
