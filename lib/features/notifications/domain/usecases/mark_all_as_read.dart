import 'package:dartz/dartz.dart';
import 'package:fintrack/features/notifications/domain/entities/notification_item.dart';
import 'package:fintrack/features/notifications/domain/repositories/notification_repository.dart';

class MarkAllAsRead {
  final NotificationRepository repository;

  MarkAllAsRead(this.repository);

  Future<Either<String, List<NotificationItem>>> call() async {
    return await repository.markAllAsRead();
  }
}
