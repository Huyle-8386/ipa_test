import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/add_transaction/data/model/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AddTxRemoteDataSource {
  Future<void> saveTransaction(TransactionModel model);
}

class AddTxRemoteDataSourceImpl implements AddTxRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  AddTxRemoteDataSourceImpl({required this.firestore, required this.auth});

  @override
  Future<void> saveTransaction(TransactionModel model) async {
    // 1. Bắt buộc phải có user
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    final uid = user.uid;

    // 2. Chuẩn bị json
    // final data = model.toJson(uid: uid);
    final data = model.toJson();

    // 3. Lưu đúng path users/{uid}/transactions/{autoId}
    await firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .add(data);
  }
}
