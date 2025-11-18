import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fintrack/features/notifications/domain/entities/notification_item.dart';
import 'package:fintrack/features/notifications/domain/usecases/get_notifications.dart';
import 'package:fintrack/features/notifications/domain/usecases/mark_as_read.dart';
import 'package:fintrack/features/notifications/domain/usecases/mark_all_as_read.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotifications getNotifications;
  final MarkAsRead markAsRead;
  final MarkAllAsRead markAllAsRead;

  NotificationsBloc({
    required this.getNotifications,
    required this.markAsRead,
    required this.markAllAsRead,
  }) : super(NotificationsState.initial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<MarkAllAsReadEvent>(_onMarkAllAsRead);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await getNotifications();

    result.fold(
      (error) => emit(state.copyWith(
        isLoading: false,
        errorMessage: error,
      )),
      (notifications) => emit(state.copyWith(
        notifications: notifications,
        isLoading: false,
      )),
    );
  }

  Future<void> _onMarkAsRead(
    MarkAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await markAsRead.call(event.notificationId);

    result.fold(
      (error) => emit(state.copyWith(errorMessage: error)),
      (updatedNotification) {
        final updatedNotifications = <NotificationItem>[];
        for (final notif in state.notifications) {
          if (notif.id == event.notificationId) {
            updatedNotifications.add(updatedNotification);
          } else {
            updatedNotifications.add(notif);
          }
        }

        emit(state.copyWith(notifications: updatedNotifications));
      },
    );
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await markAllAsRead.call();

    result.fold(
      (error) => emit(state.copyWith(errorMessage: error)),
      (notifications) => emit(state.copyWith(notifications: notifications)),
    );
  }
}
