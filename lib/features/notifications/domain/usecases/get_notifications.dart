import 'package:dartz/dartz.dart';
import 'package:fintrack/features/notifications/domain/entities/notification_item.dart';
import 'package:fintrack/features/notifications/domain/repositories/notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Future<Either<String, List<NotificationItem>>> call() async {
    return await repository.getNotifications();
  }
}
