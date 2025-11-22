import 'package:dartz/dartz.dart';
import 'package:fintrack/features/ai_chat/domain/entities/chat_session.dart';
import 'package:fintrack/features/ai_chat/domain/repositories/chat_repository.dart';

class CreateNewChatSession {
  final ChatRepository repository;

  CreateNewChatSession(this.repository);

  Future<Either<String, ChatSession>> call() async {
    return await repository.createNewSession();
  }
}
