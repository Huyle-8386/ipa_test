import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/size_utils.dart';

import '../../domain/entities/chat_message.dart';
import '../bloc/chat_bloc/chat_bloc.dart';
import '../bloc/chat_detail_bloc/chat_detail_bloc.dart';
import 'widgets/chat_bubble_user.dart';
import 'widgets/chat_bubble_bot.dart';
import 'widgets/chat_input_field.dart';

class ChatDetailPage extends StatefulWidget {
  final String uid;

  const ChatDetailPage({super.key, required this.uid});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessages(widget.uid));
  }

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,

        title: Text(
          "AI Chat",
          style: AppTextStyles.body1.copyWith(
            fontSize: w * 0.04,
            color: AppColors.white,
          ),
        ),
      ),

      body: Column(
        children: [
          // Logo AI
          Padding(
            padding: EdgeInsets.symmetric(vertical: h * 0.015),
            child: Image.asset(
              'assets/icons/AI_logo.png',
              width: w * 0.10,
              height: w * 0.10,
            ),
          ),

          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                _scrollToBottom();

                if (state.messages.isEmpty) {
                  return Center(
                    child: Text(
                      "Start a conversation",
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.grey,
                        fontSize: w * 0.035,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final msg = state.messages[index];

                    return msg.isBot
                        ? ChatBubbleBot(message: msg.message, h: h, w: w)
                        : ChatBubbleUser(message: msg.message, h: h, w: w);
                  },
                );
              },
            ),
          ),

          // Input bar
          Padding(
            padding: EdgeInsets.only(bottom: h * 0.03),
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, chatState) {
                final bool isBotTyping = chatState.isBotTyping;

                return ChatInputField(
                  h: h,
                  w: w,
                  isSending: isBotTyping,
                  onSend: (text) {
                    context.read<ChatBloc>().add(UserSendMessageEvent());

                    context.read<ChatDetailBloc>().add(
                      SendMessageEvent(widget.uid, text),
                    );
                  },
                  onRegenerate: () {
                    final lastUserMessage = chatState.messages
                        .lastWhere((m) => !m.isBot)
                        .message;

                    context.read<ChatDetailBloc>().add(
                      RegenerateMessageEvent(widget.uid, lastUserMessage),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
