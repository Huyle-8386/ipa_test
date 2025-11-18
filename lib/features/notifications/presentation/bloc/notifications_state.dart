part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  final List<NotificationItem> notifications;
  final bool isLoading;
  final String? errorMessage;

  const NotificationsState({
    required this.notifications,
    required this.isLoading,
    this.errorMessage,
  });

  factory NotificationsState.initial() {
    return const NotificationsState(
      notifications: [],
      isLoading: false,
    );
  }

  NotificationsState copyWith({
    List<NotificationItem>? notifications,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [notifications, isLoading, errorMessage];
}
