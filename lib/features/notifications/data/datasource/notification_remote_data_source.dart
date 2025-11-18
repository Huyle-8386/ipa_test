import 'package:fintrack/features/notifications/data/model/notification_item_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationItemModel>> getNotifications();
  Future<NotificationItemModel> markAsRead(String notificationId);
  Future<List<NotificationItemModel>> markAllAsRead();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final List<NotificationItemModel> _notifications = [
    const NotificationItemModel(
      id: 'notif_1',
      iconPath: 'assets/icons/new_transaction.png',
      title: 'New Transaction',
      time: 'Today | 8:21 AM',
      description: 'You received a payment of \$50',
      isUnread: true,
    ),
    const NotificationItemModel(
      id: 'notif_2',
      iconPath: 'assets/icons/bill_reminder.png',
      title: 'Bill Reminder',
      time: 'Today | 10:42 AM',
      description: 'Don\'t forget to pay your electricity bill by the end of the week',
      isUnread: true,
    ),
    const NotificationItemModel(
      id: 'notif_3',
      iconPath: 'assets/icons/alert.png',
      title: 'Budget Alert',
      time: '1 day ago | 11:42 PM',
      description: 'You\'ve exceeded 90% of your monthly budget for "Groceries"',
      isUnread: true,
    ),
    const NotificationItemModel(
      id: 'notif_4',
      iconPath: 'assets/icons/alert.png',
      title: 'Expense Alert',
      time: '2 days ago | 11:25 PM',
      description: 'Your recent grocery expense was higher than usual. Review your spending.',
      isUnread: false,
    ),
  ];

  @override
  Future<List<NotificationItemModel>> getNotifications() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_notifications);
  }

  @override
  Future<NotificationItemModel> markAsRead(String notificationId) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      final updated = _notifications[index].copyWith(isUnread: false);
      _notifications[index] = updated;
      return updated;
    }
    throw Exception('Notification not found');
  }

  @override
  Future<List<NotificationItemModel>> markAllAsRead() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));

    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isUnread: false);
    }

    return List.from(_notifications);
  }
}
