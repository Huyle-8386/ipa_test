class ChatMessage {
  final String id;
  final bool isUser;
  final String userName;
  final String message;
  final String time;
  final bool showRegenerate;

  ChatMessage({
    required this.id,
    required this.isUser,
    required this.userName,
    required this.message,
    required this.time,
    this.showRegenerate = false,
  });
}

class ChatSession {
  final String id;
  final String title;
  final DateTime lastMessageTime;

  ChatSession({
    required this.id,
    required this.title,
    required this.lastMessageTime,
  });
}

// Mock data
final List<ChatSession> chatSessions = [
  ChatSession(
    id: 'session_1',
    title: 'Can you recommend investment strategy...',
    lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
  ),
  ChatSession(
    id: 'session_2',
    title: 'Help me set a monthly savings goal',
    lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
  ),
  ChatSession(
    id: 'session_3',
    title: 'Budget planning for next month',
    lastMessageTime: DateTime.now().subtract(const Duration(days: 3)),
  ),
  ChatSession(
    id: 'session_4',
    title: 'Track my expenses',
    lastMessageTime: DateTime.now().subtract(const Duration(days: 5)),
  ),
];

// Mock messages for demo
List<ChatMessage> getMessagesForSession(String sessionId) {
  return [
    ChatMessage(
      id: '${sessionId}_msg_1',
      isUser: true,
      userName: 'Phung Thanh Hao',
      message: 'Help me set a monthly savings goal',
      time: '10:30 AM',
    ),
    ChatMessage(
      id: '${sessionId}_msg_2',
      isUser: false,
      userName: 'AI Chat',
      message: 'Of course! What are you saving for, and how much do you want to save?',
      time: '10:30 AM',
    ),
    ChatMessage(
      id: '${sessionId}_msg_3',
      isUser: true,
      userName: 'Phung Thanh Hao',
      message: 'I\'m saving for a vacation, and I want to save \$1,200 in 6 months.',
      time: '10:31 AM',
    ),
    ChatMessage(
      id: '${sessionId}_msg_4',
      isUser: false,
      userName: 'AI Chat',
      message: 'Great! To achieve that, you\'ll need to save \$200 per month. Would you like to set up an automatic transfer from your checking account to a dedicated savings account for this goal?',
      time: '10:31 AM',
      showRegenerate: true,
    ),
  ];
}
