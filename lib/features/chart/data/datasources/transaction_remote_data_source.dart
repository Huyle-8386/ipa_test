import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/transaction_entity.dart';
import '../models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionEntity>> getTransactions();
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  TransactionRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final snap = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .get();

    return snap.docs.map((doc) => TransactionModel.fromFirestore(doc)).toList();
  }
}
