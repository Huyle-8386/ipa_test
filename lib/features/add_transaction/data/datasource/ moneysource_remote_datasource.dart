import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/add_transaction/data/model/money_source_model.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class MoneySourceRemoteDataSource {
  Future<List<MoneySourceEntity>> getMoneySources(); // ✅
  Future<void> incrementBalance({
    required String moneySourceId,
    required double delta, // >0: cộng, <0: trừ
  });

  Future<MoneySourceEntity?> getMoneySourceById(String id);
}

class MoneySourceRemoteDataSourceImpl implements MoneySourceRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  MoneySourceRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Future<List<MoneySourceEntity>> getMoneySources() async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    final uid = user.uid;

    final snap = await firestore
        .collection("users")
        .doc(uid)
        .collection('money_sources')
        .get();

    return snap.docs.map((doc) => MoneySourceModel.fromFirestore(doc)).toList();
  }

  @override
  Future<void> incrementBalance({
    required String moneySourceId,
    required double delta,
  }) async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    final uid = user.uid;

    await firestore
        .collection('users')
        .doc(uid)
        .collection('money_sources')
        .doc(moneySourceId)
        .update({'balance': FieldValue.increment(delta)});
  }

  @override
  Future<MoneySourceEntity?> getMoneySourceById(String id) async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    final uid = user.uid;

    final doc = await firestore
        .collection('users')
        .doc(uid)
        .collection('money_sources')
        .doc(id)
        .get();

    if (!doc.exists) return null;

    return MoneySourceModel.fromFirestore(doc);
  }
}
