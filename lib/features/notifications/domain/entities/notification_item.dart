import 'package:equatable/equatable.dart';

class NotificationItem extends Equatable {
  final String id;
  final String iconPath;
  final String title;
  final String time;
  final String description;
  final bool isUnread;

  const NotificationItem({
    required this.id,
    required this.iconPath,
    required this.title,
    required this.time,
    required this.description,
    required this.isUnread,
  });

  @override
  List<Object?> get props => [id, iconPath, title, time, description, isUnread];
}
