import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:fintrack/features/notifications/data/datasource/notification_remote_data_source.dart';
import 'package:fintrack/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:fintrack/features/notifications/domain/usecases/get_notifications.dart';
import 'package:fintrack/features/notifications/domain/usecases/mark_as_read.dart';
import 'package:fintrack/features/notifications/domain/usecases/mark_all_as_read.dart';
import 'package:fintrack/features/notifications/domain/entities/notification_item.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Setup dependencies
    final remoteDataSource = NotificationRemoteDataSourceImpl();
    final repository = NotificationRepositoryImpl(remoteDataSource: remoteDataSource);
    final getNotifications = GetNotifications(repository);
    final markAsRead = MarkAsRead(repository);
    final markAllAsRead = MarkAllAsRead(repository);

    return BlocProvider(
      create: (context) => NotificationsBloc(
        getNotifications: getNotifications,
        markAsRead: markAsRead,
        markAllAsRead: markAllAsRead,
      )..add(LoadNotifications()),
      child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: AppTextStyles.body1.copyWith(
            color: AppColors.white,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<NotificationsBloc>().add(MarkAllAsReadEvent());
            },
            child: Text(
              'Mark all as read',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.main,
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.notifications.isEmpty) {
            return Center(
              child: Text(
                'No notifications',
                style: AppTextStyles.body2.copyWith(color: AppColors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.notifications.length,
            itemBuilder: (context, index) {
              final notification = state.notifications[index];
              return _buildNotificationCard(context, notification);
            },
          );
        },
      ),
    ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.widget,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Image.asset(
            notification.iconPath,
            width: 48,
            height: 48,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Expanded(
                      child: Text(
                        notification.title,
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    
                    // Unread Indicator
                    if (notification.isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 4, left: 8),
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                
                // Time
                Text(
                  notification.time,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.grey,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Description
                Text(
                  notification.description,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
