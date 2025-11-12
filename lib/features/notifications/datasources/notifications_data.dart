class NotificationItem {
  final String id;
  final String iconPath;
  final String title;
  final String time;
  final String description;
  final bool isUnread;

  NotificationItem({
    required this.id,
    required this.iconPath,
    required this.title,
    required this.time,
    required this.description,
    this.isUnread = false,
  });

  NotificationItem copyWith({
    String? id,
    String? iconPath,
    String? title,
    String? time,
    String? description,
    bool? isUnread,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      iconPath: iconPath ?? this.iconPath,
      title: title ?? this.title,
      time: time ?? this.time,
      description: description ?? this.description,
      isUnread: isUnread ?? this.isUnread,
    );
  }
}

final List<NotificationItem> notifications = [
  NotificationItem(
    id: 'notif_1',
    iconPath: 'assets/icons/new_transaction.png',
    title: 'New Transaction',
    time: 'Today | 8:21 AM',
    description: 'You received a payment of \$50',
    isUnread: true,
  ),
  NotificationItem(
    id: 'notif_2',
    iconPath: 'assets/icons/bill_reminder.png',
    title: 'Bill Reminder',
    time: 'Today | 10:42 AM',
    description: 'Don\'t forget to pay your electricity bill by the end of the week',
    isUnread: true,
  ),
  NotificationItem(
    id: 'notif_3',
    iconPath: 'assets/icons/alert.png',
    title: 'Budget Alert',
    time: '1 day ago | 11:42 PM',
    description: 'You\'ve exceeded 90% of your monthly budget for "Groceries"',
    isUnread: true,
  ),
  NotificationItem(
    id: 'notif_4',
    iconPath: 'assets/icons/alert.png',
    title: 'Expense Alert',
    time: '2 days ago | 11:25 PM',
    description: 'Your recent grocery expense was higher than usual. Review your spending.',
    isUnread: false,
  ),
];
