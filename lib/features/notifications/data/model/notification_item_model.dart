import 'package:fintrack/features/notifications/domain/entities/notification_item.dart';

class NotificationItemModel extends NotificationItem {
  const NotificationItemModel({
    required super.id,
    required super.iconPath,
    required super.title,
    required super.time,
    required super.description,
    required super.isUnread,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: json['id'] as String,
      iconPath: json['iconPath'] as String,
      title: json['title'] as String,
      time: json['time'] as String,
      description: json['description'] as String,
      isUnread: json['isUnread'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'iconPath': iconPath,
      'title': title,
      'time': time,
      'description': description,
      'isUnread': isUnread,
    };
  }

  NotificationItemModel copyWith({
    String? id,
    String? iconPath,
    String? title,
    String? time,
    String? description,
    bool? isUnread,
  }) {
    return NotificationItemModel(
      id: id ?? this.id,
      iconPath: iconPath ?? this.iconPath,
      title: title ?? this.title,
      time: time ?? this.time,
      description: description ?? this.description,
      isUnread: isUnread ?? this.isUnread,
    );
  }
}
