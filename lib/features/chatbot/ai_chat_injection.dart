import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Data
import '../../core/di/injector.dart';
import '../../features/chatbot/data/datasource/chat_remote_data_source_impl.dart';
import '../../features/chatbot/data/repositories/chat_repository_impl.dart';

// Domain
import '../../features/chatbot/domain/usecases/get_messages_stream.dart';
import '../../features/chatbot/domain/usecases/send_user_message.dart';
import '../../features/chatbot/domain/usecases/send_bot_message.dart';

// BLoC
import '../../features/chatbot/presentation/bloc/chat_bloc/chat_bloc.dart';
import '../../features/chatbot/presentation/bloc/chat_detail_bloc/chat_detail_bloc.dart';
import 'data/datasource/chat_remote_data_source.dart';
import 'domain/repositories/chat_repository.dart';

final sl = GetIt.instance;

Future<void> initChatbotModule() async {
  /// Firebase
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  /// DATASOURCE
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(sl<FirebaseFirestore>()),
  );

  /// REPOSITORY
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl<ChatRemoteDataSource>()),
  );

  /// USECASES
  sl.registerLazySingleton(() => GetMessagesStream(sl<ChatRepository>()));
  sl.registerLazySingleton(() => SendUserMessage(sl<ChatRepository>()));
  sl.registerLazySingleton(() => SendBotMessage(sl<ChatRepository>()));

  /// BLOCS
  sl.registerFactory(
    () => ChatBloc(getMessagesStream: sl<GetMessagesStream>()),
  );
  sl.registerFactory(
    () => ChatDetailBloc(sendUserMessage: sl<SendUserMessage>()),
  );
}
