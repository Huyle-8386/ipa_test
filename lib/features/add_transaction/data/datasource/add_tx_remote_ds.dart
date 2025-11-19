import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/add_transaction/data/model/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

// abstract class AddTxRemoteDataSource {
//   Future<void> saveTransaction(TransactionModel model);
// }

// class AddTxRemoteDataSourceImpl implements AddTxRemoteDataSource {
//   final FirebaseFirestore firestore;
//   final FirebaseAuth auth;

//   AddTxRemoteDataSourceImpl({
//     required this.firestore,
//     required this.auth,
//   });

//   @override
//   Future<void> saveTransaction(TransactionModel model) async {
//     final user = auth.currentUser;
//     final uid = user?.uid;
//     final data = model.toJson(uid: uid);
//     await firestore.collection('users').doc(uid).collection('transactions').add(data);
//   }
// }