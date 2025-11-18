import 'package:dartz/dartz.dart';
import 'package:fintrack/features/notifications/domain/entities/notification_item.dart';

abstract class NotificationRepository {
  Future<Either<String, List<NotificationItem>>> getNotifications();
  Future<Either<String, NotificationItem>> markAsRead(String notificationId);
  Future<Either<String, List<NotificationItem>>> markAllAsRead();
}
