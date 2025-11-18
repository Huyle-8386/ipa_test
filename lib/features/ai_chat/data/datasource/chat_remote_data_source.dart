import 'package:fintrack/features/ai_chat/data/model/chat_session_model.dart';
import 'package:fintrack/features/ai_chat/data/model/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatSessionModel>> getChatSessions();
  Future<ChatSessionModel> createNewSession();
  Future<List<ChatMessageModel>> getMessages(String sessionId);
  Future<ChatMessageModel> sendMessage(String sessionId, String message);
  Future<ChatMessageModel> regenerateMessage(String messageId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  @override
  Future<List<ChatSessionModel>> getChatSessions() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock data
    return [
      ChatSessionModel(
        id: 'session_1',
        title: 'Can you recommend investment strategy...',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ChatSessionModel(
        id: 'session_2',
        title: 'Help me set a monthly savings goal',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ChatSessionModel(
        id: 'session_3',
        title: 'Budget planning for next month',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 3)),
      ),
      ChatSessionModel(
        id: 'session_4',
        title: 'Track my expenses',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  @override
  Future<ChatSessionModel> createNewSession() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));

    return ChatSessionModel(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      title: 'New Chat',
      lastMessageTime: DateTime.now(),
    );
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String sessionId) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock messages
    return [
      ChatMessageModel(
        id: '${sessionId}_msg_1',
        isUser: true,
        userName: 'Phung Hao',
        message: 'Help me set a monthly savings goal',
        time: '10:30 AM',
      ),
      ChatMessageModel(
        id: '${sessionId}_msg_2',
        isUser: false,
        userName: 'AI Chat',
        message: 'Of course! What are you saving for, and how much do you want to save?',
        time: '10:30 AM',
      ),
      ChatMessageModel(
        id: '${sessionId}_msg_3',
        isUser: true,
        userName: 'Phung Hao',
        message: 'I\'m saving for a vacation, and I want to save \$1,200 in 6 months.',
        time: '10:31 AM',
      ),
      ChatMessageModel(
        id: '${sessionId}_msg_4',
        isUser: false,
        userName: 'AI Chat',
        message: 'Great! To achieve that, you\'ll need to save \$200 per month. Would you like to set up an automatic transfer from your checking account to a dedicated savings account for this goal?',
        time: '10:31 AM',
        showRegenerate: true,
      ),
    ];
  }

  @override
  Future<ChatMessageModel> sendMessage(String sessionId, String message) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Return AI response
    return ChatMessageModel(
      id: '${sessionId}_msg_${DateTime.now().millisecondsSinceEpoch}',
      isUser: false,
      userName: 'AI Chat',
      message: 'Thank you for your message. I\'m here to help you with your financial questions!',
      time: _formatTime(DateTime.now()),
      showRegenerate: true,
    );
  }

  @override
  Future<ChatMessageModel> regenerateMessage(String messageId) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    return ChatMessageModel(
      id: messageId,
      isUser: false,
      userName: 'AI Chat',
      message: 'Here\'s a regenerated response. I can help you better understand your financial situation.',
      time: _formatTime(DateTime.now()),
      showRegenerate: true,
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
