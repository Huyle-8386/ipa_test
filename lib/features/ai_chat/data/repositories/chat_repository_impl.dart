import 'package:dartz/dartz.dart';
import 'package:fintrack/features/ai_chat/data/datasources/chat_remote_data_source.dart';
import 'package:fintrack/features/ai_chat/domain/entities/chat_session.dart';
import 'package:fintrack/features/ai_chat/domain/entities/chat_message.dart';
import 'package:fintrack/features/ai_chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<ChatSession>>> getChatSessions() async {
    try {
      final sessions = await remoteDataSource.getChatSessions();
      return Right(sessions);
    } catch (e) {
      return Left('Failed to load chat sessions: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, ChatSession>> createNewSession() async {
    try {
      final session = await remoteDataSource.createNewSession();
      return Right(session);
    } catch (e) {
      return Left('Failed to create new session: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<ChatMessage>>> getMessages(String sessionId) async {
    try {
      final messages = await remoteDataSource.getMessages(sessionId);
      return Right(messages);
    } catch (e) {
      return Left('Failed to load messages: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, ChatMessage>> sendMessage(String sessionId, String message) async {
    try {
      final response = await remoteDataSource.sendMessage(sessionId, message);
      return Right(response);
    } catch (e) {
      return Left('Failed to send message: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, ChatMessage>> regenerateMessage(String messageId) async {
    try {
      final message = await remoteDataSource.regenerateMessage(messageId);
      return Right(message);
    } catch (e) {
      return Left('Failed to regenerate message: ${e.toString()}');
    }
  }
}
