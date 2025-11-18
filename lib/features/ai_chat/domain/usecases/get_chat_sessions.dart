import 'package:dartz/dartz.dart';
import 'package:fintrack/features/ai_chat/domain/entities/chat_session.dart';
import 'package:fintrack/features/ai_chat/domain/repositories/chat_repository.dart';

class GetChatSessions {
  final ChatRepository repository;

  GetChatSessions(this.repository);

  Future<Either<String, List<ChatSession>>> call() async {
    return await repository.getChatSessions();
  }
}
