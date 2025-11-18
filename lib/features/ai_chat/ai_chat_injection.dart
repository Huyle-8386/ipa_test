import 'package:fintrack/features/ai_chat/data/datasource/chat_remote_data_source.dart';
import 'package:fintrack/features/ai_chat/data/repositories/chat_repository_impl.dart';
import 'package:fintrack/features/ai_chat/domain/repositories/chat_repository.dart';
import 'package:fintrack/features/ai_chat/domain/usecases/create_new_chat_session.dart';
import 'package:fintrack/features/ai_chat/domain/usecases/get_chat_sessions.dart';
import 'package:fintrack/features/ai_chat/domain/usecases/send_message.dart';
import 'package:fintrack/features/ai_chat/domain/usecases/regenerate_message.dart';
import 'package:fintrack/features/ai_chat/domain/usecases/get_messages.dart';
import 'package:fintrack/features/ai_chat/presentation/bloc/chat_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initAiChat() async {
  // datasources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(),
  );

  // repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl()),
  );

  // usecases
  sl.registerLazySingleton(() => GetChatSessions(sl()));
  sl.registerLazySingleton(() => CreateNewChatSession(sl()));
  sl.registerLazySingleton(() => GetMessages(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => RegenerateMessage(sl()));

  // bloc
  sl.registerFactory(
    () => ChatBloc(getChatSessions: sl(), createNewChatSession: sl()),
  );

  // Note: ChatDetailBloc requires sessionId parameter, so it should be created
  // on demand with the specific sessionId when navigating to chat detail page
  // Example: ChatDetailBloc(sessionId: sessionId, getMessages: sl(), sendMessage: sl(), regenerateMessage: sl())
}
