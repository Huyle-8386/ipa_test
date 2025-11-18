import 'package:fintrack/features/notifications/data/datasource/notification_remote_data_source.dart';
import 'package:fintrack/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:fintrack/features/notifications/domain/repositories/notification_repository.dart';
import 'package:fintrack/features/notifications/domain/usecases/get_notifications.dart';
import 'package:fintrack/features/notifications/domain/usecases/mark_as_read.dart';
import 'package:fintrack/features/notifications/domain/usecases/mark_all_as_read.dart';
import 'package:fintrack/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initNotifications() async {
  // datasources
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(),
  );

  // repository
  sl.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl(sl()));

  // usecases
  sl.registerLazySingleton(() => GetNotifications(sl()));
  sl.registerLazySingleton(() => MarkAsRead(sl()));
  sl.registerLazySingleton(() => MarkAllAsRead(sl()));

  // bloc
  sl.registerFactory(
    () => NotificationsBloc(
      getNotifications: sl(),
      markAsRead: sl(),
      markAllAsRead: sl(),
    ),
  );
}
