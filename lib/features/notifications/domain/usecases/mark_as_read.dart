import 'package:dartz/dartz.dart';
import 'package:fintrack/features/notifications/domain/entities/notification_item.dart';
import 'package:fintrack/features/notifications/domain/repositories/notification_repository.dart';

class MarkAsRead {
  final NotificationRepository repository;

  MarkAsRead(this.repository);

  Future<Either<String, NotificationItem>> call(String notificationId) async {
    return await repository.markAsRead(notificationId);
  }
}
