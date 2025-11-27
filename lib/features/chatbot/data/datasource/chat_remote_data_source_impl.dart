import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/chat_message_model.dart';
import 'chat_remote_data_source.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl(this.firestore);

  @override
  Stream<List<ChatMessageModel>> getMessagesStream(String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('chatbot')
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatMessageModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  @override
  Future<void> addUserMessage(String uid, String message) async {
    final data = {
      "uid": uid,
      "message": message,
      // đổi sang isBot
      "isBot": false,
      // timestamp có thể là ISO string hoặc dùng FieldValue.serverTimestamp()
      "timestamp": DateTime.now().toIso8601String(),
    };

    await firestore
        .collection('users')
        .doc(uid)
        .collection('chatbot')
        .add(data);

    /// Call webhook (nếu bạn vẫn muốn gửi tới n8n)
    try {
      await http.post(
        Uri.parse(
          "https://n8n-vietnam.id.vn/webhook/08782e75-cd6d-4bc3-8a89-05a8064e5e0f",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
    } catch (e) {
      // không block app nếu webhook lỗi
      // log or ignore
    }
  }

  @override
  Future<void> addBotMessage(String uid, String message) async {
    final data = {
      "uid": uid,
      "message": message,
      "isBot": true,
      "timestamp": DateTime.now().toIso8601String(),
    };

    await firestore
        .collection('users')
        .doc(uid)
        .collection('chatbot')
        .add(data);
  }
}
