import 'package:dartz/dartz.dart';
import 'package:fintrack/features/notifications/data/datasource/notification_remote_data_source.dart';
import 'package:fintrack/features/notifications/domain/entities/notification_item.dart';
import 'package:fintrack/features/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, List<NotificationItem>>> getNotifications() async {
    try {
      final notifications = await remoteDataSource.getNotifications();
      return Right(notifications);
    } catch (e) {
      return Left('Failed to load notifications: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, NotificationItem>> markAsRead(
    String notificationId,
  ) async {
    try {
      final notification = await remoteDataSource.markAsRead(notificationId);
      return Right(notification);
    } catch (e) {
      return Left('Failed to mark as read: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<NotificationItem>>> markAllAsRead() async {
    try {
      final notifications = await remoteDataSource.markAllAsRead();
      return Right(notifications);
    } catch (e) {
      return Left('Failed to mark all as read: ${e.toString()}');
    }
  }
}
