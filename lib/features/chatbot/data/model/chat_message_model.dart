import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  ChatMessageModel({
    required super.id,
    required super.uid,
    required super.message,
    required super.isBot,
    required super.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json, String id) {
    // parsing isBot safely
    final dynamic isBotRaw = json['isBot'];
    bool isBot = false;
    if (isBotRaw is bool) {
      isBot = isBotRaw;
    } else if (isBotRaw is String) {
      isBot = isBotRaw.toLowerCase() == 'true';
    } else if (isBotRaw is int) {
      isBot = isBotRaw != 0;
    }

    // parse timestamp safely: can be ISO string, Firestore Timestamp, or numeric millis
    DateTime timestamp = DateTime.now();
    final dynamic ts = json['timestamp'];
    if (ts is String) {
      try {
        timestamp = DateTime.parse(ts);
      } catch (_) {
        timestamp = DateTime.now();
      }
    } else if (ts is Timestamp) {
      timestamp = ts.toDate();
    } else if (ts is int) {
      // assume milliseconds since epoch
      timestamp = DateTime.fromMillisecondsSinceEpoch(ts);
    } else if (ts is Map && ts['_seconds'] != null) {
      // some Firestore export formats
      timestamp = DateTime.fromMillisecondsSinceEpoch(
        (ts['_seconds'] as int) * 1000,
      );
    }

    return ChatMessageModel(
      id: id,
      uid: (json['uid'] ?? '') as String,
      message: (json['message'] ?? '') as String,
      isBot: isBot,
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "message": message,
      "isBot": isBot,
      "timestamp": timestamp.toIso8601String(),
    };
  }
}
