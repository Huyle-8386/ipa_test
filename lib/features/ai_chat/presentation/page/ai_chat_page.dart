import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/features/ai_chat/presentation/bloc/chat_bloc.dart';
import 'package:fintrack/features/ai_chat/data/datasource/chat_remote_data_source.dart';
import 'package:fintrack/features/ai_chat/data/repositories/chat_repository_impl.dart';
import 'package:fintrack/features/ai_chat/domain/usecases/get_chat_sessions.dart';
import 'package:fintrack/features/ai_chat/domain/usecases/create_new_chat_session.dart';
import 'chat_detail_page.dart';

class AIChatPage extends StatelessWidget {
  const AIChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Setup dependencies
    final remoteDataSource = ChatRemoteDataSourceImpl();
    final repository = ChatRepositoryImpl(remoteDataSource);
    final getChatSessions = GetChatSessions(repository);
    final createNewChatSession = CreateNewChatSession(repository);

    return BlocProvider(
      create: (context) => ChatBloc(
        getChatSessions: getChatSessions,
        createNewChatSession: createNewChatSession,
      )..add(LoadChatSessions()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.widget,
              child: ClipOval(
                child: Image.asset(
                  'assets/icons/avatar_logo.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          title: Text(
            'Phung-Hao',
            style: AppTextStyles.body1.copyWith(color: AppColors.white),
          ),
          actions: [
            IconButton(
              icon: Image.asset(
                'assets/icons/notification.png',
                width: 24,
                height: 24,
              ),
              onPressed: () {
                // Navigate to notifications page
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Empty State Section
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // AI Logo
                    Image.asset(
                      'assets/icons/AI_logo.png',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 32),

                    // Welcome Text
                    Text(
                      'Welcome to',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading1.copyWith(
                        color: AppColors.white,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      'AI Chat',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading1.copyWith(
                        color: AppColors.white,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Start chatting with AI Chat now.',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // New Chat Button
                    BlocConsumer<ChatBloc, ChatState>(
                      listener: (context, state) {
                        if (state.newSessionId != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatDetailPage(
                                sessionId: state.newSessionId!,
                              ),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: state.isLoading
                                ? null
                                : () {
                                    context.read<ChatBloc>().add(
                                      CreateNewChatSessionEvent(),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.main,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: state.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                : Text(
                                    'New Chat',
                                    style: AppTextStyles.body1.copyWith(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Previous Chats Section
              BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state.sessions.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          'Previous 7 days',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      // Chat History List
                      ...state.sessions
                          .take(4)
                          .map(
                            (session) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatDetailPage(sessionId: session.id),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.widget,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.chat_bubble_outline,
                                        color: AppColors.grey,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          session.title,
                                          style: AppTextStyles.body2.copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
