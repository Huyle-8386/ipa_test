import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/features/ai_chat/presentation/bloc/chat_detail_bloc.dart';
import 'package:fintrack/features/ai_chat/data/datasource/chat_remote_data_source.dart';
import 'package:fintrack/features/ai_chat/data/repositories/chat_repository_impl.dart';
import 'package:fintrack/features/ai_chat/domain/usecases/get_messages.dart';
import 'package:fintrack/features/ai_chat/domain/usecases/send_message.dart';
import 'package:fintrack/features/ai_chat/domain/usecases/regenerate_message.dart';
import 'package:fintrack/features/ai_chat/domain/entities/chat_message.dart';

class ChatDetailScreen extends StatelessWidget {
  final String sessionId;

  const ChatDetailScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    // Setup dependencies
    final remoteDataSource = ChatRemoteDataSourceImpl();
    final repository = ChatRepositoryImpl(remoteDataSource: remoteDataSource);
    final getMessages = GetMessages(repository);
    final sendMessage = SendMessage(repository);
    final regenerateMessage = RegenerateMessage(repository);

    return BlocProvider(
      create: (context) => ChatDetailBloc(
        sessionId: sessionId,
        getMessages: getMessages,
        sendMessage: sendMessage,
        regenerateMessage: regenerateMessage,
      )..add(LoadMessages()),
      child: const _ChatDetailView(),
    );
  }
}

class _ChatDetailView extends StatefulWidget {
  const _ChatDetailView();

  @override
  State<_ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<_ChatDetailView> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<ChatDetailBloc>().add(SendMessageEvent(message));
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'AI Chat',
          style: AppTextStyles.body1.copyWith(
            color: AppColors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          // AI Logo - Below AppBar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Image.asset(
              'assets/icons/AI_logo.png',
              width: 40,
              height: 40,
            ),
          ),

          // Messages List
          Expanded(
            child: BlocBuilder<ChatDetailBloc, ChatDetailState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.messages.isEmpty) {
                  return Center(
                    child: Text(
                      'Start a conversation',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    return _buildMessageBubble(message);
                  },
                );
              },
            ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(
                top: BorderSide(color: AppColors.widget, width: 0.5),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: AppColors.grey,
                      size: 24,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.widget,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Send a message',
                                hintStyle: AppTextStyles.body2.copyWith(
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          Icon(Icons.mic_none, color: AppColors.grey, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  BlocBuilder<ChatDetailBloc, ChatDetailState>(
                    builder: (context, state) {
                      return IconButton(
                        icon: Icon(Icons.send, color: AppColors.main, size: 24),
                        onPressed: state.isSending ? null : _sendMessage,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          message.isUser
              ? CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.widget,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/icons/avatar_logo.png',
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.widget,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Image.asset('assets/icons/AI_logo.png'),
                  ),
                ),
          const SizedBox(width: 10),

          // Message Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Name
                Text(
                  message.userName,
                  style: AppTextStyles.body2.copyWith(
                    color: message.isUser ? AppColors.orange : AppColors.main,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),

                // Message Bubble
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? AppColors.widget
                        : Color(0xFF0A0A0A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message.message,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),

                // Regenerate Button (phan hoi cua AI messages)
                if (message.showRegenerate) ...[
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {
                      context.read<ChatDetailBloc>().add(
                        RegenerateMessageEvent(message.id),
                      );
                    },
                    icon: Image.asset(
                      'assets/icons/regenerate.png',
                      width: 14,
                      height: 14,
                      color: AppColors.grey,
                    ),
                    label: Text(
                      'Regenerate',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.widget, width: 1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(0, 32),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
